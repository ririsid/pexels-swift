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
    ///   - parameters: The parameters that conforming `APIParameterable`.
    ///   - headerFields: The request header fields.
    public init(method: Method, scheme: String?, authority: String?, path: String?, parameters: [APIParameterable?]?, headerFields: HTTPTypes.HTTPFields = [:]) {
        self.init(method: method,
                  scheme: scheme,
                  authority: authority,
                  path: path,
                  parameters: parameters?.compactMap({ $0 }),
                  headerFields: headerFields)
    }

    /// Create an HTTP request with values of pseudo header fields and header fields.
    /// 
    /// - Parameters:
    ///   - method: The request method.
    ///   - scheme: The value of the ":scheme" pseudo header field.
    ///   - authority: The value of the ":authority" pseudo header field.
    ///   - path: The value of the ":path" pseudo header field.
    ///   - parameters: The parameters that conforming `APIParameterable`.
    ///   - headerFields: The request header fields.
    public init(method: Method, scheme: String?, authority: String?, path: String?, parameters: [APIParameterable]?, headerFields: HTTPTypes.HTTPFields = [:]) {
        self.init(method: method,
                  scheme: scheme,
                  authority: authority,
                  path: path,
                  queryItems: parameters?.map(URLQueryItem.init),
                  headerFields: headerFields)
    }
}
