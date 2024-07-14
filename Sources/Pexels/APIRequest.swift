import Foundation
import HTTPTypes

/// An HTTP request to make requests to API services.
public struct APIRequest<Response: Decodable>: Sendable {
    private(set) var httpRequest: HTTPRequest

    /// The HTTP request method.
    public var method: HTTPRequest.Method {
        get {
            httpRequest.method
        }
    }

    /// The value of the ":scheme" pseudo header field.
    public var scheme: String? {
        get {
            httpRequest.scheme
        }
        set {
            httpRequest.scheme = newValue
        }
    }

    /// The value of the ":authority" pseudo header field.
    public var authority: String? {
        get {
            httpRequest.authority
        }
        set {
            httpRequest.authority = newValue
        }
    }

    /// The value of the ":path" pseudo header field.
    public var path: String? {
        get {
            httpRequest.path
        }
    }

    /// The request header fields.
    public var headerFields: HTTPFields {
        get {
            httpRequest.headerFields
        }
        set {
            httpRequest.headerFields = newValue
        }
    }

    /// Create a  request with values of pseudo header fields and header fields.
    ///
    /// - Parameters:
    ///   - method: The request method.
    ///   - path: The value of the ":path" pseudo header field.
    ///   - parameters: The parameters that conforming `APIParameterable`.
    public init(method: HTTPRequest.Method, path: String, parameters: [APIParameterable?]? = nil) {
        self.httpRequest = HTTPRequest(method: method, scheme: nil, authority: nil, path: path, parameters: parameters)
    }

    /// Create a request with a method, and a URL.
    ///
    /// - Parameters:
    ///   - method: The request method.
    ///   - url: The URL to populate the scheme, authority, and path pseudo header fields.
    public init(method: HTTPRequest.Method, url: URL) {
        self.httpRequest = HTTPRequest(method: method, url: url)
    }
}
