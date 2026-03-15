import CoreData
import Foundation

/// Repository for Baseline CRUD operations via Core Data
class BaselineRepository {
    private let coreData: CoreDataStack

    init(coreData: CoreDataStack = .shared) {
        self.coreData = coreData
    }

    /// Save or update baseline for a metric type (upsert)
    func save(_ baseline: Baseline) throws {
        let context = coreData.viewContext
        let request = NSFetchRequest<BaselineEntity>(entityName: "BaselineEntity")
        request.predicate = NSPredicate(format: "metricType == %@", baseline.metricType.rawValue)

        if let existing = try context.fetch(request).first {
            existing.medianValue = baseline.medianValue
            existing.sampleCount = Int32(baseline.sampleCount)
            existing.lastUpdated = baseline.lastUpdated
        } else {
            let entity = BaselineEntity(context: context)
            entity.populate(from: baseline)
        }
        try coreData.save(context: context)
    }

    func fetchAll() throws -> [Baseline] {
        let request = NSFetchRequest<BaselineEntity>(entityName: "BaselineEntity")
        return try coreData.viewContext.fetch(request).map { $0.toModel() }
    }

    func fetch(for type: MetricType) throws -> Baseline? {
        let request = NSFetchRequest<BaselineEntity>(entityName: "BaselineEntity")
        request.predicate = NSPredicate(format: "metricType == %@", type.rawValue)
        request.fetchLimit = 1
        return try coreData.viewContext.fetch(request).first?.toModel()
    }
}
