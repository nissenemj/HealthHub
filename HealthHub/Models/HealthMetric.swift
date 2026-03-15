import Foundation

/// Types of health metrics tracked by the app
enum MetricType: String, Codable, CaseIterable {
    case heartRateVariability = "hrv"
    case restingHeartRate = "resting_hr"
    case sleepDuration = "sleep_duration"
    case sleepQuality = "sleep_quality"
    case deepSleep = "deep_sleep"
    case remSleep = "rem_sleep"
    case steps = "steps"
    case activeCalories = "active_calories"
    case skinTemperature = "skin_temperature"
    case readinessScore = "readiness_score"
}

/// Source of the health metric data
enum MetricSource: String, Codable {
    case healthKit = "healthkit"
    case oura = "oura"
    case manual = "manual"
}

/// A single health metric measurement
struct HealthMetric: Identifiable, Codable {
    let id: UUID
    let type: MetricType
    let value: Double
    let unit: String
    let source: MetricSource
    let recordedAt: Date
    let createdAt: Date

    init(
        id: UUID = UUID(),
        type: MetricType,
        value: Double,
        unit: String,
        source: MetricSource,
        recordedAt: Date,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.type = type
        self.value = value
        self.unit = unit
        self.source = source
        self.recordedAt = recordedAt
        self.createdAt = createdAt
    }
}
