import Foundation
import os.log

/// Loads API keys from Secrets.plist and stores them securely in Keychain.
/// Used during development — in production, tokens come from OAuth flow.
enum SecretsLoader {
    private static let logger = Logger(subsystem: "com.healthhub.migraine", category: "Secrets")

    /// Load secrets from plist and store in Keychain (only if not already set)
    static func loadIfNeeded() {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) as? [String: String] else {
            logger.info("Secrets.plist ei löytynyt – ohitetaan")
            return
        }

        // Oura access token
        if let ouraToken = dict["OuraAccessToken"],
           !ouraToken.isEmpty,
           ouraToken != "YOUR_OURA_ACCESS_TOKEN_HERE",
           KeychainService.read(key: .ouraAccessToken) == nil {
            try? KeychainService.save(key: .ouraAccessToken, value: ouraToken)
            logger.info("Oura-token ladattu Keychainiin Secrets.plistista")
        }

        // Vision API key
        if let visionKey = dict["VisionAPIKey"],
           !visionKey.isEmpty,
           visionKey != "YOUR_CLAUDE_API_KEY_HERE",
           KeychainService.read(key: .visionAPIKey) == nil {
            try? KeychainService.save(key: .visionAPIKey, value: visionKey)
            logger.info("Vision API -avain ladattu Keychainiin Secrets.plistista")
        }
    }
}
