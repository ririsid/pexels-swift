import Foundation
import HTTPTypes

extension HTTPTypes.HTTPRequest {
    /// Create an HTTP request with values of pseudo header fields and header fields.
    ///
    /// - Parameters:
    ///   - method: The request method.
    ///   - scheme: The value of the ":scheme" pseudo header field.
    ///   - authority: The value of the ":authority" pseudo header field.
    ///   - path: The value of the ":path" pseudo header field.
    ///   - queryItems: The query items.
    ///   - headerFields: The request header fields.
    public init(method: Method, scheme: String?, authority: String?, path: String?, queryItems: [URLQueryItem]?, headerFields: HTTPTypes.HTTPFields = [:]) {
        self.init(method: method,
                  scheme: scheme,
                  authority: authority,
                  path: Self.makePath(path, with: queryItems),
                  headerFields: headerFields)
    }
    
    /// Make a path combining the query items.
    ///
    /// - Parameters:
    ///   - path: The path.
    ///   - queryItems: The query items.
    /// - Returns: New pass with query items.
    private static func makePath(_ path: String?, with queryItems: [URLQueryItem]?) -> String? {
        // If `queryItems` is nil or empty, returns the path.
        guard let queryItems, !queryItems.isEmpty else { return path }
        let query = queryItems.reduce("", {
            // If the value is `nil`, return early.
            guard let value = $1.value else { return $0 }
            
            // The first query uses "?" and the remaining queries use "&".
            let separator = $0.isEmpty ? "?" : "&"
            return "\($0)\(separator)\($1.name)=\(value)"
        })
        
        // If the query is empty, returns the path.
        guard !query.isEmpty else { return path }
        
        return "\(path ?? "")\(query)"
    }
}
