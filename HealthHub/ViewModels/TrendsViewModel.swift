import Foundation

enum TrendPeriod: String, CaseIterable {
    case week, month, quarter
}

struct TriggerSummary {
    let name: String
    let count: Int
}

/// ViewModel for trends and analytics
@MainActor
class TrendsViewModel: ObservableObject {
    @Published var selectedPeriod: TrendPeriod = .week {
        didSet { loadTrends() }
    }
    @Published var migraineCount = 0
    @Published var averageRisk: Double = 0
    @Published var averageSleep: Double = 0
    @Published var averageHRV: Double = 0
    @Published var topTriggers: [TriggerSummary] = []

    private let dataStore = DataStore.shared

    func loadTrends() {
        let days: Int
        switch selectedPeriod {
        case .week: days = 7
        case .month: days = 30
        case .quarter: days = 90
        }

        let startDate = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()

        let migraines = dataStore.migraines(since: startDate)
        migraineCount = migraines.count

        let risks = dataStore.riskAssessments(since: startDate)
        averageRisk = risks.isEmpty ? 0 : risks.map(\.riskScore).reduce(0, +) / Double(risks.count)

        let sleepMetrics = dataStore.metrics(ofType: .sleepDuration, since: startDate)
        averageSleep = sleepMetrics.isEmpty ? 0 : sleepMetrics.map(\.value).reduce(0, +) / Double(sleepMetrics.count)

        let hrvMetrics = dataStore.metrics(ofType: .heartRateVariability, since: startDate)
        averageHRV = hrvMetrics.isEmpty ? 0 : hrvMetrics.map(\.value).reduce(0, +) / Double(hrvMetrics.count)

        // Aggregate triggers from meals
        let meals = dataStore.meals(since: startDate)
        var triggerCounts: [String: Int] = [:]
        for meal in meals {
            for trigger in meal.potentialTriggers {
                triggerCounts[trigger, default: 0] += 1
            }
        }
        topTriggers = triggerCounts
            .map { TriggerSummary(name: $0.key, count: $0.value) }
            .sorted { $0.count > $1.count }
            .prefix(5)
            .map { $0 }
    }
}
