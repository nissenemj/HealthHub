import XCTest
@testable import HealthHub

final class RiskEngineTests: XCTestCase {
    let engine = RiskEngine()

    func testLowRiskWithNoMetrics() {
        let result = engine.calculateDailyRisk(metrics: [], baselines: [])
        XCTAssertEqual(result.riskLevel, .low)
        XCTAssertEqual(result.riskScore, 0)
        XCTAssert(result.factors.isEmpty)
    }

    func testBaselineDeviationCalculation() {
        let baseline = Baseline(
            metricType: .heartRateVariability,
            medianValue: 50,
            sampleCount: 14
        )

        // 20% below baseline
        XCTAssertEqual(baseline.deviationPercent(for: 40), -20, accuracy: 0.1)

        // At baseline
        XCTAssertEqual(baseline.deviationPercent(for: 50), 0, accuracy: 0.1)

        // 10% above baseline
        XCTAssertEqual(baseline.deviationPercent(for: 55), 10, accuracy: 0.1)
    }

    func testMigraineEventDuration() {
        let start = Date()
        let end = start.addingTimeInterval(3600 * 4.5) // 4.5 hours

        let event = MigraineEvent(startTime: start, endTime: end, severity: .moderate)
        XCTAssertEqual(event.durationHours ?? 0, 4.5, accuracy: 0.01)
    }

    func testMigraineEventNoDuration() {
        let event = MigraineEvent(startTime: Date(), severity: .mild)
        XCTAssertNil(event.durationHours)
    }
}
