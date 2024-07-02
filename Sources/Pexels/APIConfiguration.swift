import Foundation

/// The configuration needed to set up the API Provider including all needed information for performing API requests.
public struct APIConfiguration: APIConfigurable {
    /// Your API key. Get yours from: https://www.pexels.com/api/new/
    public let apiKey: String
    
    /// The value of the ":scheme" pseudo header field.
    public let scheme: String? = "https"
    
    /// The value of the ":authority" pseudo header field.
    public let authority: String? = "api.pexels.com"
    
    /// Create an API configuration.
    ///
    /// - Parameter apiKey: Your API key. Get yours from: https://www.pexels.com/api/new/
    public init(with apiKey: String) {
        self.apiKey = apiKey
    }
}

// MARK: - APIConfigurable

/// API configuration protocol.
public protocol APIConfigurable {
    var apiKey: String { get }
    var scheme: String? { get }
    var authority: String? { get }
}
