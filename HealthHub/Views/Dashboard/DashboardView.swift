import SwiftUI

/// Main dashboard showing daily risk assessment and key metrics
struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Risk score card
                    RiskScoreCard(
                        riskScore: viewModel.todayRisk.riskScore,
                        riskLevel: viewModel.todayRisk.riskLevel
                    )

                    // Key metrics summary
                    MetricsSummarySection(metrics: viewModel.todayMetrics)

                    // Recommendation
                    if let recommendation = viewModel.todayRisk.recommendation {
                        RecommendationCard(text: recommendation)
                    }

                    // Contributing factors
                    if !viewModel.todayRisk.factors.isEmpty {
                        FactorsSection(factors: viewModel.todayRisk.factors)
                    }

                    // Recent migraines
                    if !viewModel.recentMigraines.isEmpty {
                        RecentMigrainesSection(migraines: viewModel.recentMigraines)
                    }

                    // Context tags for today
                    ContextTagsSection(tags: viewModel.todayTags)
                }
                .padding()
            }
            .navigationTitle("HealthHub")
            .refreshable {
                await viewModel.refresh()
            }
        }
    }
}

// MARK: - Subviews

struct RiskScoreCard: View {
    let riskScore: Double
    let riskLevel: RiskLevel

    var body: some View {
        VStack(spacing: 12) {
            Text("Päivän riskitaso")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text("\(Int(riskScore))")
                .font(.system(size: 64, weight: .bold, design: .rounded))
                .foregroundStyle(riskColor)

            Text(riskLevel.label)
                .font(.title3)
                .foregroundStyle(riskColor)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var riskColor: Color {
        switch riskLevel {
        case .low: return .green
        case .moderate: return .yellow
        case .elevated: return .orange
        case .high: return .red
        }
    }
}

struct RecommendationCard: View {
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "lightbulb.fill")
                .foregroundStyle(.yellow)
                .font(.title3)
            Text(text)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.yellow.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct MetricsSummarySection: View {
    let metrics: [HealthMetric]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Mittarit")
                .font(.headline)

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(metrics) { metric in
                    MetricCard(metric: metric)
                }
            }
        }
    }
}

struct MetricCard: View {
    let metric: HealthMetric

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(metric.type.rawValue.uppercased())
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text(String(format: "%.0f", metric.value))
                .font(.title2.bold())
            Text(metric.unit)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct FactorsSection: View {
    let factors: [RiskFactor]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Riskitekijät")
                .font(.headline)

            ForEach(factors) { factor in
                HStack {
                    Text(factor.name)
                    Spacer()
                    Text("\(Int(factor.contribution * 100))%")
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal)
            }
        }
    }
}

struct RecentMigrainesSection: View {
    let migraines: [MigraineEvent]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Viimeaikaiset migreenit")
                .font(.headline)

            ForEach(migraines) { migraine in
                HStack {
                    Circle()
                        .fill(severityColor(migraine.severity))
                        .frame(width: 12, height: 12)
                    Text(migraine.startTime, style: .date)
                    Spacer()
                    Text(migraine.severity.label)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private func severityColor(_ severity: MigraineSeverity) -> Color {
        switch severity {
        case .mild: return .yellow
        case .moderate: return .orange
        case .severe: return .red
        case .debilitating: return .purple
        }
    }
}

struct ContextTagsSection: View {
    let tags: [ContextTag]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Konteksti")
                .font(.headline)

            FlowLayout(spacing: 8) {
                ForEach(tags) { tag in
                    Text(tag.category.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                }
            }
        }
    }
}

/// Simple flow layout for tags
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y), proposal: .unspecified)
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (positions: [CGPoint], size: CGSize) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }

        return (positions, CGSize(width: maxWidth, height: y + rowHeight))
    }
}
