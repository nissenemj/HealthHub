import Foundation

/// Severity level of a migraine episode
enum MigraineSeverity: Int, Codable, CaseIterable {
    case mild = 1
    case moderate = 2
    case severe = 3
    case debilitating = 4

    var label: String {
        switch self {
        case .mild: return "Lievä"
        case .moderate: return "Kohtalainen"
        case .severe: return "Voimakas"
        case .debilitating: return "Invalidisoiva"
        }
    }
}

/// A logged migraine episode
struct MigraineEvent: Identifiable, Codable {
    let id: UUID
    var startTime: Date
    var endTime: Date?
    var severity: MigraineSeverity
    var hadAura: Bool
    var symptoms: [String]
    var medications: [String]
    var notes: String
    let createdAt: Date

    init(
        id: UUID = UUID(),
        startTime: Date = Date(),
        endTime: Date? = nil,
        severity: MigraineSeverity = .moderate,
        hadAura: Bool = false,
        symptoms: [String] = [],
        medications: [String] = [],
        notes: String = "",
        createdAt: Date = Date()
    ) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.severity = severity
        self.hadAura = hadAura
        self.symptoms = symptoms
        self.medications = medications
        self.notes = notes
        self.createdAt = createdAt
    }

    /// Duration in hours, if end time is set
    var durationHours: Double? {
        guard let endTime else { return nil }
        return endTime.timeIntervalSince(startTime) / 3600
    }
}
