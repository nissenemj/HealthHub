import Foundation

/// Service for syncing data from the Oura Ring API
class OuraService {
    static let shared = OuraService()

    private let dataStore = DataStore.shared
    private let baseURL = "https://api.ouraring.com/v2"

    var accessToken: String? {
        get { UserDefaults.standard.string(forKey: "oura_access_token") }
        set { UserDefaults.standard.set(newValue, forKey: "oura_access_token") }
    }

    var isAuthenticated: Bool {
        accessToken != nil
    }

    /// Sync daily data from Oura API
    func syncDailyData() async throws {
        guard let token = accessToken else { return }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let today = dateFormatter.string(from: Date())

        try await syncSleepData(token: token, date: today)
        try await syncReadinessData(token: token, date: today)
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
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw OuraError.requestFailed
        }
        return data
    }
}

enum OuraError: Error {
    case requestFailed
    case notAuthenticated
}
