import Foundation
#if canImport(HealthKit)
import HealthKit
#endif

/// Service for syncing data from Apple HealthKit
class HealthKitService {
    static let shared = HealthKitService()

    #if canImport(HealthKit)
    private let healthStore = HKHealthStore()
    #endif

    private let dataStore = DataStore.shared

    /// Request HealthKit authorization
    func requestAuthorization() async throws {
        #if canImport(HealthKit)
        guard HKHealthStore.isHealthDataAvailable() else { return }

        let readTypes: Set<HKObjectType> = [
            HKQuantityType(.heartRateVariabilitySDNN),
            HKQuantityType(.restingHeartRate),
            HKQuantityType(.stepCount),
            HKQuantityType(.activeEnergyBurned),
            HKCategoryType(.sleepAnalysis)
        ]

        try await healthStore.requestAuthorization(toShare: [], read: readTypes)
        #endif
    }

    /// Sync today's metrics from HealthKit
    func syncTodayMetrics() async {
        #if canImport(HealthKit)
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())

        await syncQuantityMetric(
            type: HKQuantityType(.heartRateVariabilitySDNN),
            unit: HKUnit.secondUnit(with: .milli),
            metricType: .heartRateVariability,
            unitLabel: "ms",
            since: startOfDay
        )

        await syncQuantityMetric(
            type: HKQuantityType(.restingHeartRate),
            unit: HKUnit.count().unitDivided(by: .minute()),
            metricType: .restingHeartRate,
            unitLabel: "bpm",
            since: startOfDay
        )

        await syncQuantityMetric(
            type: HKQuantityType(.stepCount),
            unit: HKUnit.count(),
            metricType: .steps,
            unitLabel: "askelta",
            since: startOfDay
        )

        await syncSleepData(since: startOfDay)
        #endif
    }

    #if canImport(HealthKit)
    private func syncQuantityMetric(
        type: HKQuantityType,
        unit: HKUnit,
        metricType: MetricType,
        unitLabel: String,
        since startDate: Date
    ) async {
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date())
        let descriptor = HKSampleQueryDescriptor(
            predicates: [.quantitySample(type: type, predicate: predicate)],
            sortDescriptors: [SortDescriptor(\.endDate, order: .reverse)],
            limit: 1
        )

        do {
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
        } catch {
            print("HealthKit sync error for \(metricType.rawValue): \(error)")
        }
    }

    private func syncSleepData(since startDate: Date) async {
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date())
        let descriptor = HKSampleQueryDescriptor(
            predicates: [.categorySample(type: HKCategoryType(.sleepAnalysis), predicate: predicate)],
            sortDescriptors: [SortDescriptor(\.endDate, order: .reverse)]
        )

        do {
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
        } catch {
            print("HealthKit sleep sync error: \(error)")
        }
    }
    #endif
}
