import Foundation
import os.log

/// ViewModel for the main dashboard
@MainActor
class DashboardViewModel: ObservableObject {
    @Published var todayRisk = DailyRiskAssessment()
    @Published var todayMetrics: [HealthMetric] = []
    @Published var recentMigraines: [MigraineEvent] = []
    @Published var todayTags: [ContextTag] = []
    @Published var migraineFreeDays: Int = 0
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let riskEngine = RiskEngine()
    private let dataStore = DataStore.shared
    private let baselineCalculator = BaselineCalculator()
    private let logger = Logger(subsystem: "com.healthhub.migraine", category: "Dashboard")

    init() {
        Task { await refresh() }
    }

    /// Full refresh: sync data sources, recalculate baselines, compute risk
    func refresh() async {
        isLoading = true
        defer { isLoading = false }

        // Sync from data sources
        await HealthKitService.shared.syncTodayMetrics()
        if OuraService.shared.isAuthenticated {
            do {
                try await OuraService.shared.syncDailyData()
            } catch {
                logger.warning("Oura-synkronointi epäonnistui: \(error.localizedDescription)")
            }
        }

        // Recalculate baselines
        baselineCalculator.recalculateAll()

        // Load today's data
        todayMetrics = dataStore.metricsForToday()
        recentMigraines = dataStore.recentMigraines(limit: 5)
        todayTags = dataStore.tagsForToday()

        // Calculate risk
        let baselines = dataStore.allBaselines()
        todayRisk = riskEngine.calculateDailyRisk(
            metrics: todayMetrics,
            baselines: baselines,
            contextTags: todayTags
        )

        // Save today's risk assessment
        dataStore.saveRiskAssessment(todayRisk)

        // Calculate migraine-free days
        if let lastMigraine = recentMigraines.first {
            migraineFreeDays = Calendar.current.dateComponents(
                [.day], from: lastMigraine.startTime, to: Date()
            ).day ?? 0
        } else {
            migraineFreeDays = 0
        }

        logger.info("Dashboard päivitetty: riski=\(self.todayRisk.riskScore, privacy: .public), taso=\(self.todayRisk.riskLevel.rawValue)")
    }
}
