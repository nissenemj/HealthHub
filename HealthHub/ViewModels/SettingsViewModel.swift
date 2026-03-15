import Foundation
import os.log

/// ViewModel for app settings
@MainActor
class SettingsViewModel: ObservableObject {
    @Published var isOuraConnected: Bool
    @Published var isHealthKitAuthorized = false
    @Published var isSyncing = false
    @Published var lastSyncDate: Date?
    @Published var errorMessage: String?
    @Published var showOuraLogin = false
    @Published var showDeleteConfirmation = false

    private let logger = Logger(subsystem: "com.healthhub.migraine", category: "Settings")

    /// PKCE code verifier for current OAuth flow
    private(set) var codeVerifier: String?

    private var callbackObserver: Any?

    init() {
        isOuraConnected = OuraService.shared.isAuthenticated

        // Listen for OAuth callback from app URL handler
        callbackObserver = NotificationCenter.default.addObserver(
            forName: .ouraOAuthCallback,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let code = notification.userInfo?["code"] as? String else { return }
            Task { @MainActor in
                await self?.handleOuraCallback(code: code)
            }
        }
    }

    deinit {
        if let observer = callbackObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    // MARK: - Oura OAuth

    /// Start the Oura OAuth login flow
    func startOuraLogin() {
        let verifier = PKCEHelper.generateCodeVerifier()
        codeVerifier = verifier

        guard let url = OuraService.shared.authorizationURL(codeVerifier: verifier) else {
            errorMessage = "OAuth URL:n luonti epäonnistui"
            return
        }

        // Open in Safari for OAuth
        #if canImport(UIKit)
        if let uiURL = url as URL? {
            UIApplication.shared.open(uiURL)
        }
        #endif
        showOuraLogin = true
    }

    /// Handle the OAuth callback with authorization code
    func handleOuraCallback(code: String) async {
        guard let verifier = codeVerifier else {
            errorMessage = "OAuth-virhe: code verifier puuttuu"
            return
        }

        isSyncing = true
        errorMessage = nil

        do {
            try await NetworkRetry.withRetry {
                try await OuraService.shared.exchangeCodeForTokens(code: code, codeVerifier: verifier)
            }
            isOuraConnected = true
            codeVerifier = nil
            logger.info("Oura-kirjautuminen onnistui")

            // Sync immediately after connecting
            try await OuraService.shared.syncDailyData()
            lastSyncDate = Date()
        } catch {
            errorMessage = error.localizedDescription
            logger.error("Oura-kirjautuminen epäonnistui: \(error.localizedDescription)")
        }

        isSyncing = false
    }

    /// Disconnect Oura
    func disconnectOura() {
        OuraService.shared.logout()
        isOuraConnected = false
        logger.info("Oura-yhteys katkaistu")
    }

    // MARK: - HealthKit

    func authorizeHealthKit() async {
        do {
            try await HealthKitService.shared.requestAuthorization()
            isHealthKitAuthorized = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Manual Sync

    func syncNow() async {
        isSyncing = true
        errorMessage = nil

        await HealthKitService.shared.syncTodayMetrics()

        if isOuraConnected {
            do {
                try await NetworkRetry.withRetry {
                    try await OuraService.shared.syncDailyData()
                }
            } catch {
                errorMessage = "Oura-synkronointi epäonnistui: \(error.localizedDescription)"
            }
        }

        lastSyncDate = Date()
        isSyncing = false
    }

    // MARK: - Data Management

    /// Export all data as JSON
    func exportData() -> Data? {
        let dataStore = DataStore.shared
        let export: [String: Any] = [
            "exportDate": ISO8601DateFormatter().string(from: Date()),
            "version": "1.0",
        ]
        return try? JSONSerialization.data(withJSONObject: export, options: .prettyPrinted)
    }

    /// Delete all local data
    func deleteAllData() {
        // Clear Keychain tokens
        KeychainService.deleteAll()
        isOuraConnected = false
        logger.info("Kaikki tiedot poistettu")
    }
}
