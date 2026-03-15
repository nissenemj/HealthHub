import Foundation

/// ViewModel for the main dashboard
@MainActor
class DashboardViewModel: ObservableObject {
    @Published var todayRisk = DailyRiskAssessment()
    @Published var todayMetrics: [HealthMetric] = []
    @Published var recentMigraines: [MigraineEvent] = []
    @Published var todayTags: [ContextTag] = []
    @Published var isLoading = false

    private let riskEngine = RiskEngine()
    private let dataStore = DataStore.shared

    init() {
        Task { await refresh() }
    }

    func refresh() async {
        isLoading = true
        defer { isLoading = false }

        todayMetrics = dataStore.metricsForToday()
        recentMigraines = dataStore.recentMigraines(limit: 5)
        todayTags = dataStore.tagsForToday()
        todayRisk = riskEngine.calculateDailyRisk(metrics: todayMetrics, baselines: dataStore.allBaselines())
    }
}
