import Foundation

/// Unified data access layer backed by Core Data repositories
/// Provides a clean API for ViewModels while delegating to typed repositories
class DataStore {
    static let shared = DataStore()

    private let metricRepo = HealthMetricRepository()
    private let mealRepo = MealRepository()
    private let migraineRepo = MigraineRepository()
    private let baselineRepo = BaselineRepository()
    private let riskRepo = RiskAssessmentRepository()
    private let tagRepo = ContextTagRepository()

    private init() {}

    // MARK: - Metrics

    func saveMetric(_ metric: HealthMetric) {
        try? metricRepo.save(metric)
    }

    func metricsForToday() -> [HealthMetric] {
        (try? metricRepo.fetchForToday()) ?? []
    }

    func metrics(ofType type: MetricType, since date: Date) -> [HealthMetric] {
        (try? metricRepo.fetch(ofType: type, since: date)) ?? []
    }

    // MARK: - Meals

    func saveMeal(_ meal: MealEntry) {
        try? mealRepo.save(meal)
    }

    func allMeals() -> [MealEntry] {
        (try? mealRepo.fetchAll()) ?? []
    }

    func meals(since date: Date) -> [MealEntry] {
        (try? mealRepo.fetch(since: date)) ?? []
    }

    func deleteMeal(_ meal: MealEntry) {
        try? mealRepo.delete(meal)
    }

    // MARK: - Migraines

    func saveMigraine(_ event: MigraineEvent) {
        try? migraineRepo.save(event)
    }

    func allMigraines() -> [MigraineEvent] {
        (try? migraineRepo.fetchAll()) ?? []
    }

    func recentMigraines(limit: Int) -> [MigraineEvent] {
        (try? migraineRepo.fetchRecent(limit: limit)) ?? []
    }

    func migraines(since date: Date) -> [MigraineEvent] {
        (try? migraineRepo.fetch(since: date)) ?? []
    }

    func deleteMigraine(_ event: MigraineEvent) {
        try? migraineRepo.delete(event)
    }

    // MARK: - Baselines

    func saveBaseline(_ baseline: Baseline) {
        try? baselineRepo.save(baseline)
    }

    func allBaselines() -> [Baseline] {
        (try? baselineRepo.fetchAll()) ?? []
    }

    func baseline(for type: MetricType) -> Baseline? {
        try? baselineRepo.fetch(for: type)
    }

    // MARK: - Risk Assessments

    func saveRiskAssessment(_ assessment: DailyRiskAssessment) {
        try? riskRepo.save(assessment)
    }

    func riskAssessments(since date: Date) -> [DailyRiskAssessment] {
        (try? riskRepo.fetch(since: date)) ?? []
    }

    // MARK: - Context Tags

    func saveTag(_ tag: ContextTag) {
        try? tagRepo.save(tag)
    }

    func tagsForToday() -> [ContextTag] {
        (try? tagRepo.fetchForToday()) ?? []
    }
}
