import SwiftUI

/// App settings: integrations, sync, and data management
struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()

    var body: some View {
        NavigationStack {
            Form {
                // Integrations
                Section("Integraatiot") {
                    // HealthKit
                    HStack {
                        Label("Apple Health", systemImage: "heart.fill")
                        Spacer()
                        if viewModel.isHealthKitAuthorized {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        } else {
                            Button("Yhdistä") {
                                Task { await viewModel.authorizeHealthKit() }
                            }
                            .buttonStyle(.bordered)
                        }
                    }

                    // Oura
                    HStack {
                        Label("Oura Ring", systemImage: "circle.circle.fill")
                        Spacer()
                        if viewModel.isOuraConnected {
                            Button("Katkaise") {
                                viewModel.disconnectOura()
                            }
                            .foregroundStyle(.red)
                        } else {
                            Button("Yhdistä") {
                                viewModel.startOuraLogin()
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                }

                // Sync
                Section("Synkronointi") {
                    Button {
                        Task { await viewModel.syncNow() }
                    } label: {
                        HStack {
                            Label("Synkronoi nyt", systemImage: "arrow.triangle.2.circlepath")
                            Spacer()
                            if viewModel.isSyncing {
                                ProgressView()
                            }
                        }
                    }
                    .disabled(viewModel.isSyncing)

                    if let lastSync = viewModel.lastSyncDate {
                        HStack {
                            Text("Viimeisin synkronointi")
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(lastSync, style: .relative)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                // Data management
                Section("Tietojen hallinta") {
                    Button {
                        if let data = viewModel.exportData() {
                            // Share sheet would be triggered here
                            _ = data
                        }
                    } label: {
                        Label("Vie tiedot (JSON)", systemImage: "square.and.arrow.up")
                    }

                    Button(role: .destructive) {
                        viewModel.showDeleteConfirmation = true
                    } label: {
                        Label("Poista kaikki tiedot", systemImage: "trash")
                    }
                }

                // About
                Section("Tietoa") {
                    HStack {
                        Text("Versio")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }

                    HStack {
                        Text("Tietosuoja")
                        Spacer()
                        Text("Kaikki data pysyy laitteellasi")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Asetukset")
            .alert("Virhe", isPresented: .init(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Button("OK") { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .alert("Poista kaikki tiedot?", isPresented: $viewModel.showDeleteConfirmation) {
                Button("Peruuta", role: .cancel) {}
                Button("Poista", role: .destructive) {
                    viewModel.deleteAllData()
                }
            } message: {
                Text("Tämä poistaa kaikki terveystiedot, ateriakirjaukset ja migreenihistorian pysyvästi. Toimintoa ei voi peruuttaa.")
            }
        }
    }
}
