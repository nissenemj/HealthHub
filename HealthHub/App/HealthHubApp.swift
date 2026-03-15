import SwiftUI

@main
struct HealthHubApp: App {

    init() {
        // Register background tasks before scene setup
        BackgroundTaskManager.shared.registerTasks()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .onAppear {
                    setupOnLaunch()
                }
                .onOpenURL { url in
                    handleOAuthCallback(url: url)
                }
        }
    }

    private func setupOnLaunch() {
        // Schedule background tasks
        BackgroundTaskManager.shared.scheduleAllTasks()

        // Start HealthKit observer queries
        #if canImport(HealthKit)
        Task {
            try? await HealthKitService.shared.requestAuthorization()
            HealthKitService.shared.startObserverQueries()
            HealthKitService.shared.enableBackgroundDelivery()
            await HealthKitService.shared.syncTodayMetrics()
        }
        #endif

        // Sync Oura data if authenticated
        if OuraService.shared.isAuthenticated {
            Task {
                try? await OuraService.shared.syncDailyData()
            }
        }
    }

    /// Handle Oura OAuth callback URL (healthhub://oura/callback?code=...)
    private func handleOAuthCallback(url: URL) {
        guard url.scheme == "healthhub",
              url.host == "oura",
              url.path == "/callback",
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let code = components.queryItems?.first(where: { $0.name == "code" })?.value
        else { return }

        // Post notification for SettingsViewModel to handle
        NotificationCenter.default.post(
            name: .ouraOAuthCallback,
            object: nil,
            userInfo: ["code": code]
        )
    }
}

extension Notification.Name {
    static let ouraOAuthCallback = Notification.Name("ouraOAuthCallback")
}
