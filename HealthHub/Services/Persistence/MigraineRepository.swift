import CoreData
import Foundation

/// Repository for MigraineEvent CRUD operations via Core Data
class MigraineRepository {
    private let coreData: CoreDataStack

    init(coreData: CoreDataStack = .shared) {
        self.coreData = coreData
    }

    func save(_ event: MigraineEvent) throws {
        let context = coreData.viewContext
        let entity = MigraineEventEntity(context: context)
        entity.populate(from: event)
        try coreData.save(context: context)
    }

    func fetchAll() throws -> [MigraineEvent] {
        let request = NSFetchRequest<MigraineEventEntity>(entityName: "MigraineEventEntity")
        request.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: false)]
        return try coreData.viewContext.fetch(request).map { $0.toModel() }
    }

    func fetchRecent(limit: Int) throws -> [MigraineEvent] {
        let request = NSFetchRequest<MigraineEventEntity>(entityName: "MigraineEventEntity")
        request.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: false)]
        request.fetchLimit = limit
        return try coreData.viewContext.fetch(request).map { $0.toModel() }
    }

    func fetch(since date: Date) throws -> [MigraineEvent] {
        let request = NSFetchRequest<MigraineEventEntity>(entityName: "MigraineEventEntity")
        request.predicate = NSPredicate(format: "startTime >= %@", date as NSDate)
        request.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: false)]
        return try coreData.viewContext.fetch(request).map { $0.toModel() }
    }

    func delete(_ event: MigraineEvent) throws {
        let request = NSFetchRequest<MigraineEventEntity>(entityName: "MigraineEventEntity")
        request.predicate = NSPredicate(format: "id == %@", event.id as CVarArg)
        if let entity = try coreData.viewContext.fetch(request).first {
            coreData.viewContext.delete(entity)
            try coreData.save()
        }
    }
}
