import Foundation

/// ViewModel for meal logging
@MainActor
class MealLogViewModel: ObservableObject {
    @Published var meals: [MealEntry] = []

    private let dataStore = DataStore.shared

    func loadMeals() {
        meals = dataStore.allMeals()
    }

    func addMeal(_ meal: MealEntry) {
        dataStore.saveMeal(meal)
        meals.insert(meal, at: 0)
    }

    func deleteMeals(at offsets: IndexSet) {
        for index in offsets {
            dataStore.deleteMeal(meals[index])
        }
        meals.remove(atOffsets: offsets)
    }
}
