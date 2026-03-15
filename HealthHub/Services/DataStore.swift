import Foundation

/// Local data store for MVP (in-memory with UserDefaults persistence)
/// Will be replaced with Core Data in production
class DataStore {
    static let shared = DataStore()

    private var metrics: [HealthMetric] = []
    private var meals: [MealEntry] = []
    private var migraines: [MigraineEvent] = []
    private var baselines: [Baseline] = []
    private var riskAssessments: [DailyRiskAssessment] = []
    private var contextTags: [ContextTag] = []

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private init() {
        loadFromDisk()
    }

    // MARK: - Metrics

    func saveMetric(_ metric: HealthMetric) {
        metrics.append(metric)
        persist()
    }

    func metricsForToday() -> [HealthMetric] {
        let calendar = Calendar.current
        return metrics.filter { calendar.isDateInToday($0.recordedAt) }
    }

    func metrics(ofType type: MetricType, since date: Date) -> [HealthMetric] {
        metrics.filter { $0.type == type && $0.recordedAt >= date }
    }

    // MARK: - Meals

    func saveMeal(_ meal: MealEntry) {
        meals.insert(meal, at: 0)
        persist()
    }

    func allMeals() -> [MealEntry] {
        meals.sorted { $0.mealTime > $1.mealTime }
    }

    func meals(since date: Date) -> [MealEntry] {
        meals.filter { $0.mealTime >= date }
    }

    func deleteMeal(_ meal: MealEntry) {
        meals.removeAll { $0.id == meal.id }
        persist()
    }

    // MARK: - Migraines

    func saveMigraine(_ event: MigraineEvent) {
        migraines.insert(event, at: 0)
        persist()
    }

    func allMigraines() -> [MigraineEvent] {
        migraines.sorted { $0.startTime > $1.startTime }
    }

    func recentMigraines(limit: Int) -> [MigraineEvent] {
        Array(allMigraines().prefix(limit))
    }

    func migraines(since date: Date) -> [MigraineEvent] {
        migraines.filter { $0.startTime >= date }
    }

    func deleteMigraine(_ event: MigraineEvent) {
        migraines.removeAll { $0.id == event.id }
        persist()
    }

    // MARK: - Baselines

    func saveBaseline(_ baseline: Baseline) {
        if let index = baselines.firstIndex(where: { $0.metricType == baseline.metricType }) {
            baselines[index] = baseline
        } else {
            baselines.append(baseline)
        }
        persist()
    }

    func allBaselines() -> [Baseline] {
        baselines
    }

    func baseline(for type: MetricType) -> Baseline? {
        baselines.first { $0.metricType == type }
    }

    // MARK: - Risk Assessments

    func saveRiskAssessment(_ assessment: DailyRiskAssessment) {
        riskAssessments.append(assessment)
        persist()
    }

    func riskAssessments(since date: Date) -> [DailyRiskAssessment] {
        riskAssessments.filter { $0.date >= date }
    }

    // MARK: - Context Tags

    func saveTag(_ tag: ContextTag) {
        contextTags.append(tag)
        persist()
    }

    func tagsForToday() -> [ContextTag] {
        let calendar = Calendar.current
        return contextTags.filter { calendar.isDateInToday($0.date) }
    }

    // MARK: - Persistence

    private func persist() {
        let defaults = UserDefaults.standard
        if let data = try? encoder.encode(metrics) { defaults.set(data, forKey: "metrics") }
        if let data = try? encoder.encode(meals) { defaults.set(data, forKey: "meals") }
        if let data = try? encoder.encode(migraines) { defaults.set(data, forKey: "migraines") }
        if let data = try? encoder.encode(baselines) { defaults.set(data, forKey: "baselines") }
        if let data = try? encoder.encode(riskAssessments) { defaults.set(data, forKey: "riskAssessments") }
        if let data = try? encoder.encode(contextTags) { defaults.set(data, forKey: "contextTags") }
    }

    private func loadFromDisk() {
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: "metrics") { metrics = (try? decoder.decode([HealthMetric].self, from: data)) ?? [] }
        if let data = defaults.data(forKey: "meals") { meals = (try? decoder.decode([MealEntry].self, from: data)) ?? [] }
        if let data = defaults.data(forKey: "migraines") { migraines = (try? decoder.decode([MigraineEvent].self, from: data)) ?? [] }
        if let data = defaults.data(forKey: "baselines") { baselines = (try? decoder.decode([Baseline].self, from: data)) ?? [] }
        if let data = defaults.data(forKey: "riskAssessments") { riskAssessments = (try? decoder.decode([DailyRiskAssessment].self, from: data)) ?? [] }
        if let data = defaults.data(forKey: "contextTags") { contextTags = (try? decoder.decode([ContextTag].self, from: data)) ?? [] }
    }
}
