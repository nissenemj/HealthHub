import Foundation

/// Predefined context categories
enum ContextCategory: String, Codable, CaseIterable {
    case travel = "Matkailu"
    case stress = "Stressi"
    case alcohol = "Alkoholi"
    case hormonal = "Hormonaalinen"
    case weather = "Sää"
    case exercise = "Liikunta"
    case screenTime = "Ruutuaika"
    case dehydration = "Nestehukka"
    case skippedMeal = "Ateria väliin"
    case other = "Muu"
}

/// Manual annotation for contextual factors
struct ContextTag: Identifiable, Codable {
    let id: UUID
    let category: ContextCategory
    var note: String
    let date: Date
    let createdAt: Date

    init(
        id: UUID = UUID(),
        category: ContextCategory,
        note: String = "",
        date: Date = Date(),
        createdAt: Date = Date()
    ) {
        self.id = id
        self.category = category
        self.note = note
        self.date = date
        self.createdAt = createdAt
    }
}
