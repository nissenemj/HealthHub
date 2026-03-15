import CoreData
import Foundation

/// Repository for ContextTag CRUD operations via Core Data
class ContextTagRepository {
    private let coreData: CoreDataStack

    init(coreData: CoreDataStack = .shared) {
        self.coreData = coreData
    }

    func save(_ tag: ContextTag) throws {
        let context = coreData.viewContext
        let entity = ContextTagEntity(context: context)
        entity.populate(from: tag)
        try coreData.save(context: context)
    }

    func fetchForToday() throws -> [ContextTag] {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let request = NSFetchRequest<ContextTagEntity>(entityName: "ContextTagEntity")
        request.predicate = NSPredicate(format: "date >= %@", startOfDay as NSDate)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        return try coreData.viewContext.fetch(request).map { $0.toModel() }
    }

    func fetch(since date: Date) throws -> [ContextTag] {
        let request = NSFetchRequest<ContextTagEntity>(entityName: "ContextTagEntity")
        request.predicate = NSPredicate(format: "date >= %@", date as NSDate)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        return try coreData.viewContext.fetch(request).map { $0.toModel() }
    }
}
