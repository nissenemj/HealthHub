import CoreData
import Foundation

// MARK: - HealthMetricEntity

@objc(HealthMetricEntity)
class HealthMetricEntity: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var metricType: String
    @NSManaged var value: Double
    @NSManaged var unit: String
    @NSManaged var source: String
    @NSManaged var recordedAt: Date
    @NSManaged var createdAt: Date

    func toModel() -> HealthMetric {
        HealthMetric(
            id: id,
            type: MetricType(rawValue: metricType) ?? .heartRateVariability,
            value: value,
            unit: unit,
            source: MetricSource(rawValue: source) ?? .manual,
            recordedAt: recordedAt,
            createdAt: createdAt
        )
    }

    func populate(from model: HealthMetric) {
        id = model.id
        metricType = model.type.rawValue
        value = model.value
        unit = model.unit
        source = model.source.rawValue
        recordedAt = model.recordedAt
        createdAt = model.createdAt
    }
}

// MARK: - MealEntryEntity

@objc(MealEntryEntity)
class MealEntryEntity: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var photoPath: String?
    @NSManaged var mealDescription: String?
    @NSManaged var ingredientsJSON: String?
    @NSManaged var potentialTriggersJSON: String?
    @NSManaged var mealTime: Date
    @NSManaged var notes: String?
    @NSManaged var createdAt: Date

    private static let encoder = JSONEncoder()
    private static let decoder = JSONDecoder()

    func toModel() -> MealEntry {
        let ingredients: [String] = (try? Self.decoder.decode([String].self, from: Data((ingredientsJSON ?? "[]").utf8))) ?? []
        let triggers: [String] = (try? Self.decoder.decode([String].self, from: Data((potentialTriggersJSON ?? "[]").utf8))) ?? []

        return MealEntry(
            id: id,
            photoData: nil, // Photo loaded from photoPath on demand
            mealDescription: mealDescription ?? "",
            ingredients: ingredients,
            potentialTriggers: triggers,
            mealTime: mealTime,
            notes: notes ?? "",
            createdAt: createdAt
        )
    }

    func populate(from model: MealEntry) {
        id = model.id
        mealDescription = model.mealDescription
        ingredientsJSON = (try? String(data: Self.encoder.encode(model.ingredients), encoding: .utf8)) ?? "[]"
        potentialTriggersJSON = (try? String(data: Self.encoder.encode(model.potentialTriggers), encoding: .utf8)) ?? "[]"
        mealTime = model.mealTime
        notes = model.notes
        createdAt = model.createdAt
    }
}

// MARK: - MigraineEventEntity

@objc(MigraineEventEntity)
class MigraineEventEntity: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var startTime: Date
    @NSManaged var endTime: Date?
    @NSManaged var severity: Int16
    @NSManaged var hadAura: Bool
    @NSManaged var symptomsJSON: String?
    @NSManaged var medicationsJSON: String?
    @NSManaged var notes: String?
    @NSManaged var createdAt: Date

    private static let encoder = JSONEncoder()
    private static let decoder = JSONDecoder()

    func toModel() -> MigraineEvent {
        let symptoms: [String] = (try? Self.decoder.decode([String].self, from: Data((symptomsJSON ?? "[]").utf8))) ?? []
        let medications: [String] = (try? Self.decoder.decode([String].self, from: Data((medicationsJSON ?? "[]").utf8))) ?? []

        return MigraineEvent(
            id: id,
            startTime: startTime,
            endTime: endTime,
            severity: MigraineSeverity(rawValue: Int(severity)) ?? .moderate,
            hadAura: hadAura,
            symptoms: symptoms,
            medications: medications,
            notes: notes ?? "",
            createdAt: createdAt
        )
    }

    func populate(from model: MigraineEvent) {
        id = model.id
        startTime = model.startTime
        endTime = model.endTime
        severity = Int16(model.severity.rawValue)
        hadAura = model.hadAura
        symptomsJSON = (try? String(data: Self.encoder.encode(model.symptoms), encoding: .utf8)) ?? "[]"
        medicationsJSON = (try? String(data: Self.encoder.encode(model.medications), encoding: .utf8)) ?? "[]"
        notes = model.notes
        createdAt = model.createdAt
    }
}

// MARK: - ContextTagEntity

@objc(ContextTagEntity)
class ContextTagEntity: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var category: String
    @NSManaged var note: String?
    @NSManaged var date: Date
    @NSManaged var createdAt: Date

    func toModel() -> ContextTag {
        ContextTag(
            id: id,
            category: ContextCategory(rawValue: category) ?? .other,
            note: note ?? "",
            date: date,
            createdAt: createdAt
        )
    }

    func populate(from model: ContextTag) {
        id = model.id
        category = model.category.rawValue
        note = model.note
        date = model.date
        createdAt = model.createdAt
    }
}

// MARK: - DailyRiskAssessmentEntity

@objc(DailyRiskAssessmentEntity)
class DailyRiskAssessmentEntity: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var date: Date
    @NSManaged var riskScore: Double
    @NSManaged var riskLevel: String
    @NSManaged var factorsJSON: String?
    @NSManaged var recommendation: String?
    @NSManaged var createdAt: Date

    private static let encoder = JSONEncoder()
    private static let decoder = JSONDecoder()

    func toModel() -> DailyRiskAssessment {
        let factors: [RiskFactor] = (try? Self.decoder.decode([RiskFactor].self, from: Data((factorsJSON ?? "[]").utf8))) ?? []

        return DailyRiskAssessment(
            id: id,
            date: date,
            riskScore: riskScore,
            riskLevel: RiskLevel(rawValue: riskLevel) ?? .low,
            factors: factors,
            recommendation: recommendation,
            createdAt: createdAt
        )
    }

    func populate(from model: DailyRiskAssessment) {
        id = model.id
        date = model.date
        riskScore = model.riskScore
        riskLevel = model.riskLevel.rawValue
        factorsJSON = (try? String(data: Self.encoder.encode(model.factors), encoding: .utf8)) ?? "[]"
        recommendation = model.recommendation
        createdAt = model.createdAt
    }
}

// MARK: - BaselineEntity

@objc(BaselineEntity)
class BaselineEntity: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var metricType: String
    @NSManaged var medianValue: Double
    @NSManaged var sampleCount: Int32
    @NSManaged var lastUpdated: Date

    func toModel() -> Baseline {
        Baseline(
            id: id,
            metricType: MetricType(rawValue: metricType) ?? .heartRateVariability,
            medianValue: medianValue,
            sampleCount: Int(sampleCount),
            lastUpdated: lastUpdated
        )
    }

    func populate(from model: Baseline) {
        id = model.id
        metricType = model.metricType.rawValue
        medianValue = model.medianValue
        sampleCount = Int32(model.sampleCount)
        lastUpdated = model.lastUpdated
    }
}
