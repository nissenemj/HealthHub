import CoreData
import Foundation

/// Repository for HealthMetric CRUD operations via Core Data
class HealthMetricRepository {
    private let coreData: CoreDataStack

    init(coreData: CoreDataStack = .shared) {
        self.coreData = coreData
    }

    func save(_ metric: HealthMetric) throws {
        let context = coreData.viewContext
        let entity = HealthMetricEntity(context: context)
        entity.populate(from: metric)
        try coreData.save(context: context)
    }

    func saveBatch(_ metrics: [HealthMetric]) throws {
        let context = coreData.newBackgroundContext()
        context.performAndWait {
            for metric in metrics {
                let entity = HealthMetricEntity(context: context)
                entity.populate(from: metric)
            }
        }
        try coreData.save(context: context)
    }

    func fetchForToday() throws -> [HealthMetric] {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        return try fetch(predicate: NSPredicate(format: "recordedAt >= %@", startOfDay as NSDate))
    }

    func fetch(ofType type: MetricType, since date: Date) throws -> [HealthMetric] {
        try fetch(predicate: NSPredicate(
            format: "metricType == %@ AND recordedAt >= %@",
            type.rawValue, date as NSDate
        ))
    }

    func fetchAll(since date: Date) throws -> [HealthMetric] {
        try fetch(predicate: NSPredicate(format: "recordedAt >= %@", date as NSDate))
    }

    private func fetch(predicate: NSPredicate) throws -> [HealthMetric] {
        let request = NSFetchRequest<HealthMetricEntity>(entityName: "HealthMetricEntity")
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "recordedAt", ascending: false)]
        return try coreData.viewContext.fetch(request).map { $0.toModel() }
    }
}
