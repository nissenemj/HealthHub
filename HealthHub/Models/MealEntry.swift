import Foundation

/// A logged meal with optional photo analysis
struct MealEntry: Identifiable, Codable {
    let id: UUID
    var photoData: Data?
    var mealDescription: String
    var ingredients: [String]
    var potentialTriggers: [String]
    var mealTime: Date
    var notes: String
    let createdAt: Date

    init(
        id: UUID = UUID(),
        photoData: Data? = nil,
        mealDescription: String = "",
        ingredients: [String] = [],
        potentialTriggers: [String] = [],
        mealTime: Date = Date(),
        notes: String = "",
        createdAt: Date = Date()
    ) {
        self.id = id
        self.photoData = photoData
        self.mealDescription = mealDescription
        self.ingredients = ingredients
        self.potentialTriggers = potentialTriggers
        self.mealTime = mealTime
        self.notes = notes
        self.createdAt = createdAt
    }
}
