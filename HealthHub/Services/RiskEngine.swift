import Foundation

/// Rule-based migraine risk calculation engine (MVP)
///
/// Weights:
/// - HRV deviation: 35%
/// - Sleep deficit: 25%
/// - Resting heart rate elevation: 20%
/// - Context factors: 20%
class RiskEngine {

    struct Weights {
        static let hrv: Double = 0.35
        static let sleep: Double = 0.25
        static let restingHR: Double = 0.20
        static let context: Double = 0.20
    }

    func calculateDailyRisk(
        metrics: [HealthMetric],
        baselines: [Baseline],
        contextTags: [ContextTag] = []
    ) -> DailyRiskAssessment {
        var factors: [RiskFactor] = []
        var totalScore: Double = 0

        // HRV component
        if let hrvMetric = metrics.first(where: { $0.type == .heartRateVariability }),
           let hrvBaseline = baselines.first(where: { $0.metricType == .heartRateVariability }) {
            let deviation = hrvBaseline.deviationPercent(for: hrvMetric.value)
            // Lower HRV = higher risk
            let component = max(0, min(1, -deviation / 30)) * Weights.hrv * 100
            if component > 5 {
                factors.append(RiskFactor(
                    name: "HRV poikkeama",
                    contribution: Weights.hrv,
                    detail: String(format: "%.0f%% alle perusviivan", -deviation)
                ))
            }
            totalScore += component
        }

        // Sleep component
        if let sleepMetric = metrics.first(where: { $0.type == .sleepDuration }),
           let sleepBaseline = baselines.first(where: { $0.metricType == .sleepDuration }) {
            let deficit = sleepBaseline.medianValue - sleepMetric.value
            let component = max(0, min(1, deficit / 3)) * Weights.sleep * 100
            if component > 5 {
                factors.append(RiskFactor(
                    name: "Univaje",
                    contribution: Weights.sleep,
                    detail: String(format: "%.1f h vajetta", deficit)
                ))
            }
            totalScore += component
        }

        // Resting heart rate component
        if let hrMetric = metrics.first(where: { $0.type == .restingHeartRate }),
           let hrBaseline = baselines.first(where: { $0.metricType == .restingHeartRate }) {
            let elevation = hrBaseline.deviationPercent(for: hrMetric.value)
            let component = max(0, min(1, elevation / 20)) * Weights.restingHR * 100
            if component > 5 {
                factors.append(RiskFactor(
                    name: "Leposyke koholla",
                    contribution: Weights.restingHR,
                    detail: String(format: "%.0f%% yli perusviivan", elevation)
                ))
            }
            totalScore += component
        }

        // Context component
        if !contextTags.isEmpty {
            let highRiskTags: Set<ContextCategory> = [.stress, .alcohol, .dehydration, .skippedMeal]
            let riskyCount = contextTags.filter { highRiskTags.contains($0.category) }.count
            let component = min(1, Double(riskyCount) / 3) * Weights.context * 100
            if component > 0 {
                let tagNames = contextTags.map(\.category.rawValue).joined(separator: ", ")
                factors.append(RiskFactor(
                    name: "Konteksti",
                    contribution: Weights.context,
                    detail: tagNames
                ))
            }
            totalScore += component
        }

        let riskLevel: RiskLevel
        switch totalScore {
        case 0..<25: riskLevel = .low
        case 25..<50: riskLevel = .moderate
        case 50..<75: riskLevel = .elevated
        default: riskLevel = .high
        }

        let recommendation = generateRecommendation(riskLevel: riskLevel, factors: factors)

        return DailyRiskAssessment(
            riskScore: min(100, totalScore),
            riskLevel: riskLevel,
            factors: factors,
            recommendation: recommendation
        )
    }

    /// Generate a single actionable recommendation based on the highest-contributing factor
    private func generateRecommendation(riskLevel: RiskLevel, factors: [RiskFactor]) -> String? {
        guard riskLevel != .low else { return nil }

        guard let topFactor = factors.max(by: { $0.contribution < $1.contribution }) else {
            return nil
        }

        switch topFactor.name {
        case "HRV poikkeama":
            return "HRV on laskenut – harkitse kevyempää päivää ja huolehdi nesteytyksestä."
        case "Univaje":
            return "Palautuminen jäi vajaaksi – priorisoi unta tänä iltana."
        case "Leposyke koholla":
            return "Leposyke on koholla – vältä raskasta kuormitusta ja pidä taukoja."
        case "Konteksti":
            return "Riskitekijöitä havaittu – huomioi palautuminen tänään."
        default:
            return "Riskitaso koholla – kuuntele kehoasi ja pidä huolta palautumisesta."
        }
    }
}
