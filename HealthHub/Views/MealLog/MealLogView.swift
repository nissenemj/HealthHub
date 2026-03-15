import SwiftUI

/// View for logging meals and identifying potential triggers
struct MealLogView: View {
    @StateObject private var viewModel = MealLogViewModel()
    @State private var showingCamera = false
    @State private var showingNewMeal = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.meals) { meal in
                    MealRowView(meal: meal)
                }
                .onDelete { indexSet in
                    viewModel.deleteMeals(at: indexSet)
                }
            }
            .navigationTitle("Ateriat")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingNewMeal = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewMeal) {
                NewMealView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.loadMeals()
            }
        }
    }
}

struct MealRowView: View {
    let meal: MealEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(meal.mealDescription.isEmpty ? "Ateria" : meal.mealDescription)
                    .font(.headline)
                Spacer()
                Text(meal.mealTime, style: .time)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if !meal.ingredients.isEmpty {
                Text(meal.ingredients.joined(separator: ", "))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if !meal.potentialTriggers.isEmpty {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.orange)
                        .font(.caption)
                    Text(meal.potentialTriggers.joined(separator: ", "))
                        .font(.caption)
                        .foregroundStyle(.orange)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct NewMealView: View {
    @ObservedObject var viewModel: MealLogViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var description = ""
    @State private var ingredientsText = ""
    @State private var notes = ""
    @State private var mealTime = Date()

    var body: some View {
        NavigationStack {
            Form {
                Section("Aterian tiedot") {
                    TextField("Kuvaus", text: $description)
                    DatePicker("Aika", selection: $mealTime)
                }

                Section("Ainesosat") {
                    TextField("Ainesosat (pilkulla eroteltuina)", text: $ingredientsText, axis: .vertical)
                        .lineLimit(3...6)
                }

                Section("Muistiinpanot") {
                    TextField("Muistiinpanot", text: $notes, axis: .vertical)
                        .lineLimit(2...4)
                }
            }
            .navigationTitle("Uusi ateria")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Peruuta") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Tallenna") {
                        let ingredients = ingredientsText
                            .split(separator: ",")
                            .map { $0.trimmingCharacters(in: .whitespaces) }
                        let meal = MealEntry(
                            mealDescription: description,
                            ingredients: ingredients,
                            mealTime: mealTime,
                            notes: notes
                        )
                        viewModel.addMeal(meal)
                        dismiss()
                    }
                }
            }
        }
    }
}
