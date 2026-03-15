import CoreData
import Foundation

/// Core Data stack manager for HealthHub
/// Provides NSPersistentContainer and managed object contexts
class CoreDataStack {
    static let shared = CoreDataStack()

    /// The model name matches the .xcdatamodeld file
    private let modelName = "HealthHub"

    lazy var persistentContainer: NSPersistentContainer = {
        // Create the model programmatically since we don't have Xcode-generated .xcdatamodeld
        let container = NSPersistentContainer(name: modelName, managedObjectModel: Self.createModel())

        // Enable data protection
        let storeDescription = NSPersistentStoreDescription()
        let storeURL = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("\(modelName).sqlite")
        storeDescription.url = storeURL
        storeDescription.setOption(FileProtectionType.complete as NSObject, forKey: NSPersistentStoreFileProtectionKey)
        storeDescription.shouldMigrateStoreAutomatically = true
        storeDescription.shouldInferMappingModelAutomatically = true
        container.persistentStoreDescriptions = [storeDescription]

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Core Data store failed to load: \(error), \(error.userInfo)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return container
    }()

    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func newBackgroundContext() -> NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }

    func save(context: NSManagedObjectContext? = nil) throws {
        let ctx = context ?? viewContext
        guard ctx.hasChanges else { return }
        try ctx.save()
    }

    // MARK: - Programmatic Core Data Model

    /// Creates the Core Data model programmatically
    /// This replaces the .xcdatamodeld file that Xcode would normally generate
    static func createModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()

        // HealthMetricEntity
        let healthMetric = NSEntityDescription()
        healthMetric.name = "HealthMetricEntity"
        healthMetric.managedObjectClassName = "HealthMetricEntity"
        healthMetric.properties = [
            attribute("id", .UUIDAttributeType, optional: false),
            attribute("metricType", .stringAttributeType, optional: false),
            attribute("value", .doubleAttributeType, optional: false),
            attribute("unit", .stringAttributeType, optional: false),
            attribute("source", .stringAttributeType, optional: false),
            attribute("recordedAt", .dateAttributeType, optional: false),
            attribute("createdAt", .dateAttributeType, optional: false),
        ]
        // Index on (metricType, recordedAt) for fast time-series queries
        let metricIndex = NSFetchIndexDescription(
            name: "byTypeAndDate",
            elements: [
                NSFetchIndexElementDescription(property: healthMetric.propertiesByName["metricType"]!, collationType: .binary),
                NSFetchIndexElementDescription(property: healthMetric.propertiesByName["recordedAt"]!, collationType: .binary),
            ]
        )
        healthMetric.indexes = [metricIndex]

        // MealEntryEntity
        let mealEntry = NSEntityDescription()
        mealEntry.name = "MealEntryEntity"
        mealEntry.managedObjectClassName = "MealEntryEntity"
        mealEntry.properties = [
            attribute("id", .UUIDAttributeType, optional: false),
            attribute("photoPath", .stringAttributeType, optional: true),
            attribute("mealDescription", .stringAttributeType, optional: true),
            attribute("ingredientsJSON", .stringAttributeType, optional: true),
            attribute("potentialTriggersJSON", .stringAttributeType, optional: true),
            attribute("mealTime", .dateAttributeType, optional: false),
            attribute("notes", .stringAttributeType, optional: true),
            attribute("createdAt", .dateAttributeType, optional: false),
        ]

        // MigraineEventEntity
        let migraineEvent = NSEntityDescription()
        migraineEvent.name = "MigraineEventEntity"
        migraineEvent.managedObjectClassName = "MigraineEventEntity"
        migraineEvent.properties = [
            attribute("id", .UUIDAttributeType, optional: false),
            attribute("startTime", .dateAttributeType, optional: false),
            attribute("endTime", .dateAttributeType, optional: true),
            attribute("severity", .integer16AttributeType, optional: false),
            attribute("hadAura", .booleanAttributeType, optional: false),
            attribute("symptomsJSON", .stringAttributeType, optional: true),
            attribute("medicationsJSON", .stringAttributeType, optional: true),
            attribute("notes", .stringAttributeType, optional: true),
            attribute("createdAt", .dateAttributeType, optional: false),
        ]

        // ContextTagEntity
        let contextTag = NSEntityDescription()
        contextTag.name = "ContextTagEntity"
        contextTag.managedObjectClassName = "ContextTagEntity"
        contextTag.properties = [
            attribute("id", .UUIDAttributeType, optional: false),
            attribute("category", .stringAttributeType, optional: false),
            attribute("note", .stringAttributeType, optional: true),
            attribute("date", .dateAttributeType, optional: false),
            attribute("createdAt", .dateAttributeType, optional: false),
        ]

        // DailyRiskAssessmentEntity
        let riskAssessment = NSEntityDescription()
        riskAssessment.name = "DailyRiskAssessmentEntity"
        riskAssessment.managedObjectClassName = "DailyRiskAssessmentEntity"
        riskAssessment.properties = [
            attribute("id", .UUIDAttributeType, optional: false),
            attribute("date", .dateAttributeType, optional: false),
            attribute("riskScore", .doubleAttributeType, optional: false),
            attribute("riskLevel", .stringAttributeType, optional: false),
            attribute("factorsJSON", .stringAttributeType, optional: true),
            attribute("recommendation", .stringAttributeType, optional: true),
            attribute("createdAt", .dateAttributeType, optional: false),
        ]

        // BaselineEntity
        let baseline = NSEntityDescription()
        baseline.name = "BaselineEntity"
        baseline.managedObjectClassName = "BaselineEntity"
        baseline.properties = [
            attribute("id", .UUIDAttributeType, optional: false),
            attribute("metricType", .stringAttributeType, optional: false),
            attribute("medianValue", .doubleAttributeType, optional: false),
            attribute("sampleCount", .integer32AttributeType, optional: false),
            attribute("lastUpdated", .dateAttributeType, optional: false),
        ]

        model.entities = [healthMetric, mealEntry, migraineEvent, contextTag, riskAssessment, baseline]
        return model
    }

    private static func attribute(_ name: String, _ type: NSAttributeType, optional: Bool) -> NSAttributeDescription {
        let attr = NSAttributeDescription()
        attr.name = name
        attr.attributeType = type
        attr.isOptional = optional
        return attr
    }
}
