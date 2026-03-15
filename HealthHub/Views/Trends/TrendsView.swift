import SwiftUI

/// Weekly and trend analysis view
struct TrendsView: View {
    @StateObject private var viewModel = TrendsViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Period selector
                    Picker("Ajanjakso", selection: $viewModel.selectedPeriod) {
                        Text("Viikko").tag(TrendPeriod.week)
                        Text("Kuukausi").tag(TrendPeriod.month)
                        Text("3 kk").tag(TrendPeriod.quarter)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    // Migraine frequency
                    TrendCard(title: "Migreenitiheys", value: "\(viewModel.migraineCount)", subtitle: "kohtausta")

                    // Average risk score
                    TrendCard(
                        title: "Keskimääräinen riski",
                        value: String(format: "%.0f", viewModel.averageRisk),
                        subtitle: "/ 100"
                    )

                    // Average sleep
                    TrendCard(
                        title: "Keskimääräinen uni",
                        value: String(format: "%.1f h", viewModel.averageSleep),
                        subtitle: "yössä"
                    )

                    // Average HRV
                    TrendCard(
                        title: "Keskimääräinen HRV",
                        value: String(format: "%.0f ms", viewModel.averageHRV),
                        subtitle: "sykevälivaihtelu"
                    )

                    // Top triggers
                    if !viewModel.topTriggers.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Yleisimmät herätteet")
                                .font(.headline)
                                .padding(.horizontal)

                            ForEach(viewModel.topTriggers, id: \.name) { trigger in
                                HStack {
                                    Text(trigger.name)
                                    Spacer()
                                    Text("\(trigger.count)x")
                                        .foregroundStyle(.secondary)
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Trendit")
            .onAppear {
                viewModel.loadTrends()
            }
        }
    }
}

struct TrendCard: View {
    let title: String
    let value: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(value)
                    .font(.title.bold())
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }
}
