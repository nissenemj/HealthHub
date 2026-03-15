import SwiftUI

/// Root content view with tab navigation
struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Label("Koti", systemImage: "heart.text.square")
                }
                .tag(0)

            MealLogView()
                .tabItem {
                    Label("Ateriat", systemImage: "fork.knife")
                }
                .tag(1)

            MigraineLogView()
                .tabItem {
                    Label("Migreeni", systemImage: "bolt.heart")
                }
                .tag(2)

            TrendsView()
                .tabItem {
                    Label("Trendit", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(3)
        }
        .tint(.blue)
    }
}
