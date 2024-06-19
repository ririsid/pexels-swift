import Foundation

class TestingUtility {
    /// Get `PEXELS_API_KEY` from the environment.
    static func getPexelsAPIKey(_ key: String = "PEXELS_API_KEY") -> String? {
        return ProcessInfo.processInfo.environment[key]
    }
}
