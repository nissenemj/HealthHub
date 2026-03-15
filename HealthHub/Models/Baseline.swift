import Foundation

/// Personal baseline (14-day median) for a health metric
struct Baseline: Identifiable, Codable {
    let id: UUID
    let metricType: MetricType
    var medianValue: Double
    var sampleCount: Int
    var lastUpdated: Date

    init(
        id: UUID = UUID(),
        metricType: MetricType,
        medianValue: Double,
        sampleCount: Int,
        lastUpdated: Date = Date()
    ) {
        self.id = id
        self.metricType = metricType
        self.medianValue = medianValue
        self.sampleCount = sampleCount
        self.lastUpdated = lastUpdated
    }

    /// Calculate deviation from baseline as a percentage
    func deviationPercent(for value: Double) -> Double {
        guard medianValue != 0 else { return 0 }
        return ((value - medianValue) / medianValue) * 100
    }
}
