import Foundation

/// Service for syncing data from the Oura Ring API
class OuraService {
    static let shared = OuraService()

    private let dataStore = DataStore.shared
    private let baseURL = "https://api.ouraring.com/v2"

    // MARK: - OAuth 2.0 PKCE Configuration

    private let clientID = "OURA_CLIENT_ID" // Set via environment or config
    private let redirectURI = "healthhub://oura/callback"
    private let authorizationURL = "https://cloud.ouraring.com/oauth/authorize"
    private let tokenURL = "https://api.ouraring.com/oauth/token"
    private let scopes = "daily heartrate session workout"

    /// Access token stored securely in Keychain
    var accessToken: String? {
        get { KeychainService.read(key: .ouraAccessToken) }
        set {
            if let value = newValue {
                try? KeychainService.save(key: .ouraAccessToken, value: value)
            } else {
                KeychainService.delete(key: .ouraAccessToken)
            }
        }
    }

    /// Refresh token stored securely in Keychain
    var refreshToken: String? {
        get { KeychainService.read(key: .ouraRefreshToken) }
        set {
            if let value = newValue {
                try? KeychainService.save(key: .ouraRefreshToken, value: value)
            } else {
                KeychainService.delete(key: .ouraRefreshToken)
            }
        }
    }

    var isAuthenticated: Bool {
        accessToken != nil
    }

    // MARK: - OAuth 2.0 PKCE Flow

    /// Generate the OAuth authorization URL with PKCE
    func authorizationURL(codeVerifier: String) -> URL? {
        let codeChallenge = PKCEHelper.generateCodeChallenge(from: codeVerifier)

        var components = URLComponents(string: authorizationURL)
        components?.queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "scope", value: scopes),
            URLQueryItem(name: "code_challenge", value: codeChallenge),
            URLQueryItem(name: "code_challenge_method", value: "S256"),
        ]
        return components?.url
    }

    /// Exchange authorization code for tokens
    func exchangeCodeForTokens(code: String, codeVerifier: String) async throws {
        var request = URLRequest(url: URL(string: tokenURL)!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let body = [
            "grant_type=authorization_code",
            "code=\(code)",
            "redirect_uri=\(redirectURI)",
            "client_id=\(clientID)",
            "code_verifier=\(codeVerifier)",
        ].joined(separator: "&")
        request.httpBody = body.data(using: .utf8)

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw OuraError.tokenExchangeFailed
        }

        let tokenResponse = try JSONDecoder().decode(OAuthTokenResponse.self, from: data)
        accessToken = tokenResponse.accessToken
        refreshToken = tokenResponse.refreshToken
    }

    /// Refresh the access token using the refresh token
    func refreshAccessToken() async throws {
        guard let currentRefreshToken = refreshToken else {
            throw OuraError.notAuthenticated
        }

        var request = URLRequest(url: URL(string: tokenURL)!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let body = [
            "grant_type=refresh_token",
            "refresh_token=\(currentRefreshToken)",
            "client_id=\(clientID)",
        ].joined(separator: "&")
        request.httpBody = body.data(using: .utf8)

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            // Refresh failed — clear tokens, user must re-authenticate
            logout()
            throw OuraError.tokenRefreshFailed
        }

        let tokenResponse = try JSONDecoder().decode(OAuthTokenResponse.self, from: data)
        accessToken = tokenResponse.accessToken
        refreshToken = tokenResponse.refreshToken
    }

    /// Clear all stored tokens
    func logout() {
        accessToken = nil
        refreshToken = nil
    }

    // MARK: - Data Sync

    /// Sync daily data from Oura API, with automatic token refresh on 401
    func syncDailyData() async throws {
        guard let token = accessToken else {
            throw OuraError.notAuthenticated
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let today = dateFormatter.string(from: Date())

        do {
            try await syncSleepData(token: token, date: today)
            try await syncReadinessData(token: token, date: today)
        } catch OuraError.unauthorized {
            // Try refreshing the token once
            try await refreshAccessToken()
            guard let newToken = accessToken else { throw OuraError.notAuthenticated }
            try await syncSleepData(token: newToken, date: today)
            try await syncReadinessData(token: newToken, date: today)
        }
    }

    private func syncSleepData(token: String, date: String) async throws {
        let url = URL(string: "\(baseURL)/usercollection/daily_sleep?start_date=\(date)&end_date=\(date)")!
        let data = try await fetchData(url: url, token: token)

        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
           let items = json["data"] as? [[String: Any]],
           let item = items.first {

            if let deepSleep = item["deep_sleep_duration"] as? Double {
                dataStore.saveMetric(HealthMetric(
                    type: .deepSleep,
                    value: deepSleep / 3600,
                    unit: "h",
                    source: .oura,
                    recordedAt: Date()
                ))
            }

            if let remSleep = item["rem_sleep_duration"] as? Double {
                dataStore.saveMetric(HealthMetric(
                    type: .remSleep,
                    value: remSleep / 3600,
                    unit: "h",
                    source: .oura,
                    recordedAt: Date()
                ))
            }

            if let score = item["score"] as? Double {
                dataStore.saveMetric(HealthMetric(
                    type: .sleepQuality,
                    value: score,
                    unit: "pistettä",
                    source: .oura,
                    recordedAt: Date()
                ))
            }
        }
    }

    private func syncReadinessData(token: String, date: String) async throws {
        let url = URL(string: "\(baseURL)/usercollection/daily_readiness?start_date=\(date)&end_date=\(date)")!
        let data = try await fetchData(url: url, token: token)

        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
           let items = json["data"] as? [[String: Any]],
           let item = items.first {

            if let score = item["score"] as? Double {
                dataStore.saveMetric(HealthMetric(
                    type: .readinessScore,
                    value: score,
                    unit: "pistettä",
                    source: .oura,
                    recordedAt: Date()
                ))
            }

            if let temp = item["temperature_deviation"] as? Double {
                dataStore.saveMetric(HealthMetric(
                    type: .skinTemperature,
                    value: temp,
                    unit: "°C",
                    source: .oura,
                    recordedAt: Date()
                ))
            }
        }
    }

    private func fetchData(url: URL, token: String) async throws -> Data {
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw OuraError.requestFailed
        }
        switch httpResponse.statusCode {
        case 200: return data
        case 401: throw OuraError.unauthorized
        case 429: throw OuraError.rateLimited
        default: throw OuraError.requestFailed
        }
    }
}

// MARK: - OAuth Token Response

struct OAuthTokenResponse: Codable {
    let accessToken: String
    let refreshToken: String?
    let tokenType: String
    let expiresIn: Int

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}

// MARK: - PKCE Helper

enum PKCEHelper {
    static func generateCodeVerifier() -> String {
        var bytes = [UInt8](repeating: 0, count: 32)
        _ = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
        return Data(bytes)
            .base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }

    static func generateCodeChallenge(from verifier: String) -> String {
        guard let data = verifier.data(using: .utf8) else { return "" }
        var hash = [UInt8](repeating: 0, count: 32)
        data.withUnsafeBytes { buffer in
            _ = CC_SHA256(buffer.baseAddress, CC_LONG(data.count), &hash)
        }
        return Data(hash)
            .base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}

// MARK: - Errors

enum OuraError: Error, LocalizedError {
    case requestFailed
    case notAuthenticated
    case tokenExchangeFailed
    case tokenRefreshFailed
    case unauthorized
    case rateLimited

    var errorDescription: String? {
        switch self {
        case .requestFailed: return "Oura API -pyyntö epäonnistui"
        case .notAuthenticated: return "Oura-kirjautuminen vaaditaan"
        case .tokenExchangeFailed: return "Oura-todennuskoodin vaihto epäonnistui"
        case .tokenRefreshFailed: return "Oura-tokenin uusiminen epäonnistui"
        case .unauthorized: return "Oura-istunto vanhentunut"
        case .rateLimited: return "Oura API -pyyntöraja ylitetty, yritä myöhemmin"
        }
    }
}
