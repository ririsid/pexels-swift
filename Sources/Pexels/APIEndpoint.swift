import Foundation

/// A namespace for API endpoints.
public enum APIEndpoint {
    public enum Photos {}
}

// MARK: - APIEndpointError

/// `APIEndpoint` error type.
public enum APIEndpointError: LocalizedError, Equatable {
    case missingRequiredParameter(name: String)

    /// A localized message describing what error occurred.
    public var errorDescription: String? {
        switch self {
        case .missingRequiredParameter(let name):
            LocalizedString("Required parameter '%@' is missing", name, bundle: Bundle.module, comment: "API endpoint error")
        }
    }

    // Equatable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.errorDescription == rhs.errorDescription
    }
}
