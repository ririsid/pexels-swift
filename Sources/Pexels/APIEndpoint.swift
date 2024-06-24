import Foundation

public enum APIEndpoint {
    public enum Photos {}
}

// MARK: - APIEndpointError

public enum APIEndpointError: LocalizedError, Equatable {
    case missingRequiredParameter(name: String)

    public var errorDescription: String? {
        switch self {
        case .missingRequiredParameter(let name):
            if #available(macOS 12, iOS 15, tvOS 15, watchOS 8, *) {
                String(localized: "Required parameter '\(name)' is missing", bundle: Bundle.module, comment: "API endpoint error")
            } else {
                String(format: NSLocalizedString("Required parameter '%@' is missing", bundle: Bundle.module, comment: "API endpoint error"), name)
            }
        }
    }

    // Equatable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.errorDescription == rhs.errorDescription
    }
}
