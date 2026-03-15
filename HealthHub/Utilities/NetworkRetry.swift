import Foundation
import os.log

/// Network request retry logic with exponential backoff
enum NetworkRetry {
    private static let logger = Logger(subsystem: "com.healthhub.migraine", category: "Network")

    /// Execute an async operation with exponential backoff retry
    /// - Parameters:
    ///   - maxAttempts: Maximum number of attempts (default 3)
    ///   - initialDelay: Initial delay in seconds (default 2)
    ///   - operation: The async throwing operation to execute
    /// - Returns: The result of the operation
    static func withRetry<T>(
        maxAttempts: Int = 3,
        initialDelay: TimeInterval = 2,
        operation: @Sendable () async throws -> T
    ) async throws -> T {
        var lastError: Error?
        var delay = initialDelay

        for attempt in 1...maxAttempts {
            do {
                return try await operation()
            } catch {
                lastError = error
                logger.warning("Yritys \(attempt)/\(maxAttempts) epäonnistui: \(error.localizedDescription)")

                // Don't retry on auth errors — they won't resolve with retrying
                if let ouraError = error as? OuraError,
                   ouraError == .notAuthenticated || ouraError == .tokenExchangeFailed {
                    throw error
                }

                if attempt < maxAttempts {
                    try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                    delay *= 2 // Exponential backoff
                }
            }
        }

        throw lastError!
    }
}

// Make OuraError equatable for retry logic
extension OuraError: Equatable {}
