import BackgroundTasks
import Foundation
import os.log

/// Manages BGAppRefreshTask scheduling for HealthKit and Oura sync
class BackgroundTaskManager {
    static let shared = BackgroundTaskManager()

    private let logger = Logger(subsystem: "com.healthhub.migraine", category: "BackgroundTask")

    /// Task identifiers matching Info.plist BGTaskSchedulerPermittedIdentifiers
    enum TaskID {
        static let healthKitSync = "com.healthhub.migraine.healthkit-sync"
        static let ouraSync = "com.healthhub.migraine.oura-sync"
        static let baselineUpdate = "com.healthhub.migraine.baseline-update"
    }

    /// Register all background tasks. Call from app init before scene setup.
    func registerTasks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: TaskID.healthKitSync, using: nil) { task in
            self.handleHealthKitSync(task: task as! BGAppRefreshTask)
        }

        BGTaskScheduler.shared.register(forTaskWithIdentifier: TaskID.ouraSync, using: nil) { task in
            self.handleOuraSync(task: task as! BGProcessingTask)
        }

        BGTaskScheduler.shared.register(forTaskWithIdentifier: TaskID.baselineUpdate, using: nil) { task in
            self.handleBaselineUpdate(task: task as! BGProcessingTask)
        }

        logger.info("Taustatehtävät rekisteröity")
    }

    /// Schedule all recurring background tasks
    func scheduleAllTasks() {
        scheduleHealthKitSync()
        scheduleOuraSync()
        scheduleBaselineUpdate()
    }

    // MARK: - HealthKit Sync (hourly)

    private func scheduleHealthKitSync() {
        let request = BGAppRefreshTaskRequest(identifier: TaskID.healthKitSync)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 3600) // 1 hour
        do {
            try BGTaskScheduler.shared.submit(request)
            logger.info("HealthKit-synkronointi ajastettu")
        } catch {
            logger.error("HealthKit-ajastus epäonnistui: \(error.localizedDescription)")
        }
    }

    private func handleHealthKitSync(task: BGAppRefreshTask) {
        // Schedule the next sync
        scheduleHealthKitSync()

        let syncTask = Task {
            await HealthKitService.shared.syncTodayMetrics()
        }

        task.expirationHandler = {
            syncTask.cancel()
        }

        Task {
            await syncTask.value
            task.setTaskCompleted(success: true)
        }
    }

    // MARK: - Oura Sync (once daily, morning)

    private func scheduleOuraSync() {
        let request = BGProcessingTaskRequest(identifier: TaskID.ouraSync)
        // Schedule for 7am next day
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: Date())
        components.hour = 7
        components.minute = 0
        if let scheduledDate = calendar.date(from: components),
           scheduledDate <= Date() {
            // Already past 7am today, schedule for tomorrow
            request.earliestBeginDate = calendar.date(byAdding: .day, value: 1, to: scheduledDate)
        } else {
            request.earliestBeginDate = calendar.date(from: components)
        }
        request.requiresNetworkConnectivity = true

        do {
            try BGTaskScheduler.shared.submit(request)
            logger.info("Oura-synkronointi ajastettu")
        } catch {
            logger.error("Oura-ajastus epäonnistui: \(error.localizedDescription)")
        }
    }

    private func handleOuraSync(task: BGProcessingTask) {
        scheduleOuraSync()

        let syncTask = Task {
            try await OuraService.shared.syncDailyData()
        }

        task.expirationHandler = {
            syncTask.cancel()
        }

        Task {
            do {
                try await syncTask.value
                task.setTaskCompleted(success: true)
            } catch {
                logger.error("Oura-taustasynkronointi epäonnistui: \(error.localizedDescription)")
                task.setTaskCompleted(success: false)
            }
        }
    }

    // MARK: - Baseline Update (daily)

    private func scheduleBaselineUpdate() {
        let request = BGProcessingTaskRequest(identifier: TaskID.baselineUpdate)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 86400) // 24h
        request.requiresNetworkConnectivity = false

        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            logger.error("Baseline-ajastus epäonnistui: \(error.localizedDescription)")
        }
    }

    private func handleBaselineUpdate(task: BGProcessingTask) {
        scheduleBaselineUpdate()

        let calculator = BaselineCalculator()
        calculator.recalculateAll()
        task.setTaskCompleted(success: true)
        logger.info("Baseline-päivitys valmis (tausta)")
    }
}
