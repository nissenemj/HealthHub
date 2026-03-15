import CoreData
import Foundation

/// Repository for MealEntry CRUD operations via Core Data
class MealRepository {
    private let coreData: CoreDataStack

    init(coreData: CoreDataStack = .shared) {
        self.coreData = coreData
    }

    func save(_ meal: MealEntry) throws {
        let context = coreData.viewContext
        let entity = MealEntryEntity(context: context)
        entity.populate(from: meal)
        try coreData.save(context: context)
    }

    func fetchAll() throws -> [MealEntry] {
        let request = NSFetchRequest<MealEntryEntity>(entityName: "MealEntryEntity")
        request.sortDescriptors = [NSSortDescriptor(key: "mealTime", ascending: false)]
        return try coreData.viewContext.fetch(request).map { $0.toModel() }
    }

    func fetch(since date: Date) throws -> [MealEntry] {
        let request = NSFetchRequest<MealEntryEntity>(entityName: "MealEntryEntity")
        request.predicate = NSPredicate(format: "mealTime >= %@", date as NSDate)
        request.sortDescriptors = [NSSortDescriptor(key: "mealTime", ascending: false)]
        return try coreData.viewContext.fetch(request).map { $0.toModel() }
    }

    func delete(_ meal: MealEntry) throws {
        let request = NSFetchRequest<MealEntryEntity>(entityName: "MealEntryEntity")
        request.predicate = NSPredicate(format: "id == %@", meal.id as CVarArg)
        if let entity = try coreData.viewContext.fetch(request).first {
            coreData.viewContext.delete(entity)
            try coreData.save()
        }
    }
}
