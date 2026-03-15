import Foundation

/// Risk level categories
enum RiskLevel: String, Codable {
    case low
    case moderate
    case elevated
    case high

    var label: String {
        switch self {
        case .low: return "Matala"
        case .moderate: return "Kohtalainen"
        case .elevated: return "Kohonnut"
        case .high: return "Korkea"
        }
    }
}

/// A contributing factor to the daily risk score
struct RiskFactor: Identifiable, Codable {
    let id: UUID
    let name: String
    let contribution: Double // 0.0 - 1.0
    let detail: String

    init(id: UUID = UUID(), name: String, contribution: Double, detail: String) {
        self.id = id
        self.name = name
        self.contribution = contribution
        self.detail = detail
    }
}

/// Daily migraine risk assessment
struct DailyRiskAssessment: Identifiable, Codable {
    let id: UUID
    let date: Date
    var riskScore: Double // 0.0 - 100.0
    var riskLevel: RiskLevel
    var factors: [RiskFactor]
    let createdAt: Date

    init(
        id: UUID = UUID(),
        date: Date = Date(),
        riskScore: Double = 0,
        riskLevel: RiskLevel = .low,
        factors: [RiskFactor] = [],
        createdAt: Date = Date()
    ) {
        self.id = id
        self.date = date
        self.riskScore = riskScore
        self.riskLevel = riskLevel
        self.factors = factors
        self.createdAt = createdAt
    }
}
