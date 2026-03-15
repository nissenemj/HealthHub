import Foundation

/// Calculates 14-day rolling baselines for health metrics
class BaselineCalculator {
    private let dataStore = DataStore.shared
    private let baselinePeriodDays = 14

    /// Recalculate baselines for all metric types
    func recalculateAll() {
        for type in MetricType.allCases {
            recalculate(for: type)
        }
    }

    /// Recalculate baseline for a specific metric type
    func recalculate(for type: MetricType) {
        let startDate = Calendar.current.date(
            byAdding: .day,
            value: -baselinePeriodDays,
            to: Date()
        ) ?? Date()

        let values = dataStore.metrics(ofType: type, since: startDate).map(\.value)
        guard !values.isEmpty else { return }

        let sorted = values.sorted()
        let median: Double
        if sorted.count % 2 == 0 {
            median = (sorted[sorted.count / 2 - 1] + sorted[sorted.count / 2]) / 2
        } else {
            median = sorted[sorted.count / 2]
        }

        let baseline = Baseline(
            metricType: type,
            medianValue: median,
            sampleCount: sorted.count
        )
        dataStore.saveBaseline(baseline)
    }
}
