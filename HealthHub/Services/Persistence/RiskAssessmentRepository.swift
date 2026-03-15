import CoreData
import Foundation

/// Repository for DailyRiskAssessment CRUD operations via Core Data
class RiskAssessmentRepository {
    private let coreData: CoreDataStack

    init(coreData: CoreDataStack = .shared) {
        self.coreData = coreData
    }

    func save(_ assessment: DailyRiskAssessment) throws {
        let context = coreData.viewContext
        let entity = DailyRiskAssessmentEntity(context: context)
        entity.populate(from: assessment)
        try coreData.save(context: context)
    }

    func fetch(since date: Date) throws -> [DailyRiskAssessment] {
        let request = NSFetchRequest<DailyRiskAssessmentEntity>(entityName: "DailyRiskAssessmentEntity")
        request.predicate = NSPredicate(format: "date >= %@", date as NSDate)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        return try coreData.viewContext.fetch(request).map { $0.toModel() }
    }

    func fetchToday() throws -> DailyRiskAssessment? {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let request = NSFetchRequest<DailyRiskAssessmentEntity>(entityName: "DailyRiskAssessmentEntity")
        request.predicate = NSPredicate(format: "date >= %@", startOfDay as NSDate)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        request.fetchLimit = 1
        return try coreData.viewContext.fetch(request).first?.toModel()
    }
}
