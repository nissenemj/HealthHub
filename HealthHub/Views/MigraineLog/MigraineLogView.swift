import SwiftUI

/// View for logging and viewing migraine episodes
struct MigraineLogView: View {
    @StateObject private var viewModel = MigraineLogViewModel()
    @State private var showingNewEntry = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.events) { event in
                    MigraineRowView(event: event)
                }
                .onDelete { indexSet in
                    viewModel.deleteEvents(at: indexSet)
                }
            }
            .navigationTitle("Migreenit")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingNewEntry = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewEntry) {
                NewMigraineView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.loadEvents()
            }
        }
    }
}

struct MigraineRowView: View {
    let event: MigraineEvent

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle()
                    .fill(severityColor)
                    .frame(width: 10, height: 10)
                Text(event.severity.label)
                    .font(.headline)
                if event.hadAura {
                    Text("Aura")
                        .font(.caption)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(.purple.opacity(0.2))
                        .clipShape(Capsule())
                }
                Spacer()
                Text(event.startTime, style: .date)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if let hours = event.durationHours {
                Text(String(format: "Kesto: %.1f h", hours))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if !event.symptoms.isEmpty {
                Text(event.symptoms.joined(separator: ", "))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }

    private var severityColor: Color {
        switch event.severity {
        case .mild: return .yellow
        case .moderate: return .orange
        case .severe: return .red
        case .debilitating: return .purple
        }
    }
}

struct NewMigraineView: View {
    @ObservedObject var viewModel: MigraineLogViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var startTime = Date()
    @State private var severity: MigraineSeverity = .moderate
    @State private var hadAura = false
    @State private var symptomsText = ""
    @State private var medicationsText = ""
    @State private var notes = ""

    private let commonSymptoms = [
        "Päänsärky", "Pahoinvointi", "Valoherkkyys",
        "Ääniherkkyys", "Näköhäiriöt", "Huimaus"
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section("Ajoitus") {
                    DatePicker("Alkamisaika", selection: $startTime)
                }

                Section("Voimakkuus") {
                    Picker("Voimakkuus", selection: $severity) {
                        ForEach(MigraineSeverity.allCases, id: \.self) { level in
                            Text(level.label).tag(level)
                        }
                    }
                    .pickerStyle(.segmented)

                    Toggle("Aura", isOn: $hadAura)
                }

                Section("Oireet") {
                    ForEach(commonSymptoms, id: \.self) { symptom in
                        let isSelected = symptomsText.contains(symptom)
                        Button {
                            toggleSymptom(symptom)
                        } label: {
                            HStack {
                                Text(symptom)
                                    .foregroundStyle(.primary)
                                Spacer()
                                if isSelected {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.blue)
                                }
                            }
                        }
                    }
                }

                Section("Lääkitys") {
                    TextField("Lääkitys", text: $medicationsText, axis: .vertical)
                }

                Section("Muistiinpanot") {
                    TextField("Muistiinpanot", text: $notes, axis: .vertical)
                        .lineLimit(2...4)
                }
            }
            .navigationTitle("Uusi migreeni")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Peruuta") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Tallenna") {
                        let symptoms = symptomsText
                            .split(separator: ",")
                            .map { $0.trimmingCharacters(in: .whitespaces) }
                        let medications = medicationsText
                            .split(separator: ",")
                            .map { $0.trimmingCharacters(in: .whitespaces) }
                        let event = MigraineEvent(
                            startTime: startTime,
                            severity: severity,
                            hadAura: hadAura,
                            symptoms: symptoms,
                            medications: medications,
                            notes: notes
                        )
                        viewModel.addEvent(event)
                        dismiss()
                    }
                }
            }
        }
    }

    private func toggleSymptom(_ symptom: String) {
        var parts = symptomsText.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        if let index = parts.firstIndex(of: symptom) {
            parts.remove(at: index)
        } else {
            parts.append(symptom)
        }
        symptomsText = parts.joined(separator: ", ")
    }
}
