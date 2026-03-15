import XCTest
@testable import HealthHub

// MARK: - Risk Engine Tests

final class RiskEngineTests: XCTestCase {
    let engine = RiskEngine()

    func testLowRiskWithNoMetrics() {
        let result = engine.calculateDailyRisk(metrics: [], baselines: [])
        XCTAssertEqual(result.riskLevel, .low)
        XCTAssertEqual(result.riskScore, 0)
        XCTAssert(result.factors.isEmpty)
        XCTAssertNil(result.recommendation)
    }

    func testHighRiskGeneratesRecommendation() {
        let metrics = [
            HealthMetric(type: .heartRateVariability, value: 25, unit: "ms", source: .healthKit, recordedAt: Date()),
            HealthMetric(type: .sleepDuration, value: 4, unit: "h", source: .oura, recordedAt: Date()),
            HealthMetric(type: .restingHeartRate, value: 75, unit: "bpm", source: .healthKit, recordedAt: Date()),
        ]
        let baselines = [
            Baseline(metricType: .heartRateVariability, medianValue: 50, sampleCount: 14),
            Baseline(metricType: .sleepDuration, medianValue: 7.5, sampleCount: 14),
            Baseline(metricType: .restingHeartRate, medianValue: 58, sampleCount: 14),
        ]
        let result = engine.calculateDailyRisk(metrics: metrics, baselines: baselines)
        XCTAssertGreaterThan(result.riskScore, 50)
        XCTAssertNotNil(result.recommendation)
        XCTAssertFalse(result.factors.isEmpty)
    }

    func testHRVDeviationIncreasesRisk() {
        let metrics = [
            HealthMetric(type: .heartRateVariability, value: 30, unit: "ms", source: .healthKit, recordedAt: Date()),
        ]
        let baselines = [
            Baseline(metricType: .heartRateVariability, medianValue: 50, sampleCount: 14),
        ]
        let result = engine.calculateDailyRisk(metrics: metrics, baselines: baselines)
        XCTAssertGreaterThan(result.riskScore, 0)
        XCTAssertEqual(result.factors.first?.name, "HRV poikkeama")
    }

    func testSleepDeficitIncreasesRisk() {
        let metrics = [
            HealthMetric(type: .sleepDuration, value: 4.5, unit: "h", source: .oura, recordedAt: Date()),
        ]
        let baselines = [
            Baseline(metricType: .sleepDuration, medianValue: 7.5, sampleCount: 14),
        ]
        let result = engine.calculateDailyRisk(metrics: metrics, baselines: baselines)
        XCTAssertGreaterThan(result.riskScore, 0)
        XCTAssertEqual(result.factors.first?.name, "Univaje")
    }

    func testContextTagsIncreasesRisk() {
        let tags = [
            ContextTag(category: .stress),
            ContextTag(category: .alcohol),
        ]
        let result = engine.calculateDailyRisk(metrics: [], baselines: [], contextTags: tags)
        XCTAssertGreaterThan(result.riskScore, 0)
        XCTAssertEqual(result.factors.first?.name, "Konteksti")
    }

    func testRiskLevelBoundaries() {
        // Score 0 → low
        let low = engine.calculateDailyRisk(metrics: [], baselines: [])
        XCTAssertEqual(low.riskLevel, .low)
    }
}

// MARK: - Baseline Tests

final class BaselineTests: XCTestCase {
    func testDeviationCalculation() {
        let baseline = Baseline(metricType: .heartRateVariability, medianValue: 50, sampleCount: 14)
        XCTAssertEqual(baseline.deviationPercent(for: 40), -20, accuracy: 0.1)
        XCTAssertEqual(baseline.deviationPercent(for: 50), 0, accuracy: 0.1)
        XCTAssertEqual(baseline.deviationPercent(for: 55), 10, accuracy: 0.1)
    }

    func testZeroMedianDeviationIsZero() {
        let baseline = Baseline(metricType: .steps, medianValue: 0, sampleCount: 1)
        XCTAssertEqual(baseline.deviationPercent(for: 100), 0)
    }
}

// MARK: - Migraine Event Tests

final class MigraineEventTests: XCTestCase {
    func testDurationCalculation() {
        let start = Date()
        let end = start.addingTimeInterval(3600 * 4.5)
        let event = MigraineEvent(startTime: start, endTime: end, severity: .moderate)
        XCTAssertEqual(event.durationHours ?? 0, 4.5, accuracy: 0.01)
    }

    func testNoDurationWithoutEndTime() {
        let event = MigraineEvent(startTime: Date(), severity: .mild)
        XCTAssertNil(event.durationHours)
    }

    func testSeverityLabels() {
        XCTAssertEqual(MigraineSeverity.mild.label, "Lievä")
        XCTAssertEqual(MigraineSeverity.moderate.label, "Kohtalainen")
        XCTAssertEqual(MigraineSeverity.severe.label, "Voimakas")
        XCTAssertEqual(MigraineSeverity.debilitating.label, "Invalidisoiva")
    }
}

// MARK: - Validation Tests

final class ValidationTests: XCTestCase {
    func testHealthMetricValidValue() {
        let metric = HealthMetric(type: .heartRateVariability, value: 45, unit: "ms", source: .healthKit, recordedAt: Date())
        XCTAssertNoThrow(try metric.validate())
    }

    func testHealthMetricNegativeValueFails() {
        let metric = HealthMetric(type: .heartRateVariability, value: -5, unit: "ms", source: .healthKit, recordedAt: Date())
        XCTAssertThrowsError(try metric.validate())
    }

    func testHealthMetricFutureTimeFails() {
        let futureDate = Date().addingTimeInterval(86400)
        let metric = HealthMetric(type: .steps, value: 100, unit: "askelta", source: .healthKit, recordedAt: futureDate)
        XCTAssertThrowsError(try metric.validate())
    }

    func testMigraineEndBeforeStartFails() {
        let start = Date()
        let end = start.addingTimeInterval(-3600)
        let event = MigraineEvent(startTime: start, endTime: end, severity: .moderate)
        XCTAssertThrowsError(try event.validate())
    }

    func testMigraineValidEventPasses() {
        let start = Date().addingTimeInterval(-3600)
        let end = Date()
        let event = MigraineEvent(startTime: start, endTime: end, severity: .severe)
        XCTAssertNoThrow(try event.validate())
    }

    func testBaselineZeroSampleCountFails() {
        let baseline = Baseline(metricType: .sleepDuration, medianValue: 7.5, sampleCount: 0)
        XCTAssertThrowsError(try baseline.validate())
    }

    func testBaselineNegativeMedianFails() {
        let baseline = Baseline(metricType: .sleepDuration, medianValue: -1, sampleCount: 14)
        XCTAssertThrowsError(try baseline.validate())
    }

    func testBaselineValidPasses() {
        let baseline = Baseline(metricType: .sleepDuration, medianValue: 7.5, sampleCount: 14)
        XCTAssertNoThrow(try baseline.validate())
    }
}

// MARK: - Risk Level Tests

final class RiskLevelTests: XCTestCase {
    func testRiskLevelLabels() {
        XCTAssertEqual(RiskLevel.low.label, "Matala")
        XCTAssertEqual(RiskLevel.moderate.label, "Kohtalainen")
        XCTAssertEqual(RiskLevel.elevated.label, "Kohonnut")
        XCTAssertEqual(RiskLevel.high.label, "Korkea")
    }
}

// MARK: - Context Category Tests

final class ContextCategoryTests: XCTestCase {
    func testAllCategoriesHaveLabels() {
        for category in ContextCategory.allCases {
            XCTAssertFalse(category.rawValue.isEmpty)
        }
    }
}
