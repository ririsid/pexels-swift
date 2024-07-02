import Foundation

extension URL {
    /// Get value for query parameter.
    ///
    /// - Parameter name: The query parameter's name.
    /// - Returns: Returns the value if it exists, or `nil` if not.
    func queryParameterValue(for name: String) -> String? {
        guard let urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true),
              let queryItems = urlComponents.queryItems,
              let pageItem = queryItems.first(where: { $0.name == name }),
              let value = pageItem.value else { return nil }
        return value
    }
}
