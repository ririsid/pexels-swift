import Foundation

enum TestingUtility {
    /// Get `PEXELS_API_KEY` from the environment.
    static func getPexelsAPIKey(_ key: String = "PEXELS_API_KEY") -> String? {
        return ProcessInfo.processInfo.environment[key]
    }

    /// Returns the `Data` from the JSON file for the resource named.
    static func dataFromJSON(forResource name: String) -> Data? {
        guard let url = Bundle.module.url(forResource: name, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return nil
        }
        return data
    }
}
