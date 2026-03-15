import Foundation
import os.log
#if canImport(HealthKit)
import HealthKit
#endif

/// Errors from HealthKit operations
enum HealthKitError: Error, LocalizedError {
    case notAvailable
    case authorizationDenied
    case syncFailed(String)

    var errorDescription: String? {
        switch self {
        case .notAvailable: return "HealthKit ei ole käytettävissä tällä laitteella"
        case .authorizationDenied: return "HealthKit-käyttöoikeus evätty"
        case .syncFailed(let detail): return "HealthKit-synkronointi epäonnistui: \(detail)"
        }
    }
}

/// Service for syncing data from Apple HealthKit
/// Supports foreground sync, background observer queries, and background app refresh
class HealthKitService {
    static let shared = HealthKitService()

    private let logger = Logger(subsystem: "com.healthhub.migraine", category: "HealthKit")
    private let dataStore = DataStore.shared
    private let baselineCalculator = BaselineCalculator()

    #if canImport(HealthKit)
    private let healthStore = HKHealthStore()

    /// All quantity types we read from HealthKit
    private let quantityTypes: [(hkType: HKQuantityType, unit: HKUnit, metricType: MetricType, unitLabel: String)] = [
        (.init(.heartRateVariabilitySDNN), .secondUnit(with: .milli), .heartRateVariability, "ms"),
        (.init(.restingHeartRate), .count().unitDivided(by: .minute()), .restingHeartRate, "bpm"),
        (.init(.stepCount), .count(), .steps, "askelta"),
        (.init(.activeEnergyBurned), .kilocalorie(), .activeCalories, "kcal"),
    ]

    /// All object types we request read access for
    private var allReadTypes: Set<HKObjectType> {
        var types = Set<HKObjectType>(quantityTypes.map(\.hkType))
        types.insert(HKCategoryType(.sleepAnalysis))
        return types
    }
    #endif

    // MARK: - Authorization

    /// Request HealthKit read authorization
    func requestAuthorization() async throws {
        #if canImport(HealthKit)
        guard HKHealthStore.isHealthDataAvailable() else {
            throw HealthKitError.notAvailable
        }
        try await healthStore.requestAuthorization(toShare: [], read: allReadTypes)
        logger.info("HealthKit-käyttöoikeus myönnetty")
        #else
        throw HealthKitError.notAvailable
        #endif
    }

    // MARK: - Observer Queries (real-time monitoring)

    #if canImport(HealthKit)
    /// Start observer queries for all tracked types.
    /// Call once at app launch after authorization.
    func startObserverQueries() {
        for (hkType, _, _, _) in quantityTypes {
            startObserver(for: hkType)
        }
        startObserver(for: HKCategoryType(.sleepAnalysis))
        logger.info("HKObserverQuery käynnistetty kaikille tyypeille")
    }

    private func startObserver(for type: HKObjectType) {
        let query = HKObserverQuery(sampleType: type as! HKSampleType, predicate: nil) { [weak self] _, completionHandler, error in
            if let error {
                self?.logger.error("Observer-virhe (\(type.identifier)): \(error.localizedDescription)")
                completionHandler()
                return
            }

            Task {
                await self?.syncTodayMetrics()
                completionHandler()
            }
        }
        healthStore.execute(query)
    }

    /// Enable background delivery for all tracked types.
    /// Must be called after authorization and registered in the app delegate.
    func enableBackgroundDelivery() {
        for (hkType, _, _, _) in quantityTypes {
            healthStore.enableBackgroundDelivery(for: hkType, frequency: .hourly) { success, error in
                if let error {
                    self.logger.error("Background delivery virhe (\(hkType.identifier)): \(error.localizedDescription)")
                }
            }
        }

        healthStore.enableBackgroundDelivery(for: HKCategoryType(.sleepAnalysis), frequency: .hourly) { success, error in
            if let error {
                self.logger.error("Background delivery virhe (sleep): \(error.localizedDescription)")
            }
        }
        logger.info("HealthKit background delivery rekisteröity")
    }
    #endif

    // MARK: - Foreground Sync

    /// Sync today's metrics from HealthKit. Throws on failure.
    func syncTodayMetrics() async {
        #if canImport(HealthKit)
        let startOfDay = Calendar.current.startOfDay(for: Date())

        // Sync all quantity metrics
        for (hkType, unit, metricType, unitLabel) in quantityTypes {
            do {
                try await syncQuantityMetric(
                    type: hkType,
                    unit: unit,
                    metricType: metricType,
                    unitLabel: unitLabel,
                    since: startOfDay
                )
            } catch {
                logger.error("Synkronointivirhe \(metricType.rawValue): \(error.localizedDescription)")
            }
        }

        // Sync sleep data
        do {
            try await syncSleepData(since: startOfDay)
        } catch {
            logger.error("Unidata-synkronointivirhe: \(error.localizedDescription)")
        }

        // Recalculate baselines after sync
        baselineCalculator.recalculateAll()
        logger.info("HealthKit-synkronointi valmis")
        #endif
    }

    #if canImport(HealthKit)
    private func syncQuantityMetric(
        type: HKQuantityType,
        unit: HKUnit,
        metricType: MetricType,
        unitLabel: String,
        since startDate: Date
    ) async throws {
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date())
        let descriptor = HKSampleQueryDescriptor(
            predicates: [.quantitySample(type: type, predicate: predicate)],
            sortDescriptors: [SortDescriptor(\.endDate, order: .reverse)],
            limit: 1
        )

        let samples = try await descriptor.result(for: healthStore)
        if let sample = samples.first {
            let metric = HealthMetric(
                type: metricType,
                value: sample.quantity.doubleValue(for: unit),
                unit: unitLabel,
                source: .healthKit,
                recordedAt: sample.endDate
            )
            dataStore.saveMetric(metric)
        }
    }

    private func syncSleepData(since startDate: Date) async throws {
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date())
        let descriptor = HKSampleQueryDescriptor(
            predicates: [.categorySample(type: HKCategoryType(.sleepAnalysis), predicate: predicate)],
            sortDescriptors: [SortDescriptor(\.endDate, order: .reverse)]
        )

        let samples = try await descriptor.result(for: healthStore)
        let totalSleep = samples.reduce(0.0) { total, sample in
            total + sample.endDate.timeIntervalSince(sample.startDate)
        }
        let hours = totalSleep / 3600
        if hours > 0 {
            let metric = HealthMetric(
                type: .sleepDuration,
                value: hours,
                unit: "h",
                source: .healthKit,
                recordedAt: Date()
            )
            dataStore.saveMetric(metric)
        }
    }
    #endif
}
