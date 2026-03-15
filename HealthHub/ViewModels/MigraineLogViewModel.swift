import Foundation

/// ViewModel for migraine logging
@MainActor
class MigraineLogViewModel: ObservableObject {
    @Published var events: [MigraineEvent] = []

    private let dataStore = DataStore.shared

    func loadEvents() {
        events = dataStore.allMigraines()
    }

    func addEvent(_ event: MigraineEvent) {
        dataStore.saveMigraine(event)
        events.insert(event, at: 0)
    }

    func deleteEvents(at offsets: IndexSet) {
        for index in offsets {
            dataStore.deleteMigraine(events[index])
        }
        events.remove(atOffsets: offsets)
    }
}
