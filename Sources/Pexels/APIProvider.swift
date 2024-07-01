import Foundation
import HTTPTypes
import HTTPTypesFoundation // Required for URLSession extension

/// Provides access to all API Methods. Can be used to perform API requests.
public final class APIProvider {
    /// Contains a JSON Decoder which can be reused.
    public static let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()

    /// Your monthly quota.
    private(set) var quota: APIQuota? = nil

    /// The configuration needed to set up the API Provider including all needed information for performing API requests.
    private let configuration: APIConfigurable

    /// A request session.
    private let requestSession: APIRequestSession

    /// Creates a new APIProvider instance which can be used to perform API Requests to the Pexels API.
    ///
    /// - Parameters:
    ///   - configuration: The configuration needed to set up the API Provider including all needed information for performing API requests.
    ///   - session: A request session.
    public init(configuration: APIConfigurable, session: APIRequestSession = URLSession.shared) {
        self.configuration = configuration
        self.requestSession = session
    }

    public func request<R: Decodable>(_ request: inout APIRequest<R>) async throws -> R {
        let (data, _) = try await makeRequest(&request)
        do {
            let photos = try Self.jsonDecoder.decode(R.self, from: data)
            return photos
        } catch {
            throw APIError.decodingError(localizedDescription: error.localizedDescription)
        }
    }

    private func makeRequest<R: Decodable>(_ request: inout APIRequest<R>) async throws -> (Data, HTTPResponse) {
        // Update fields
        request.scheme = configuration.scheme
        request.authority = configuration.authority
        request.headerFields[.authorization] = configuration.apiKey

        do {
            let (data, response) = try await requestSession.data(for: request.httpRequest)
            quota = APIQuota(headerFields: response.headerFields)
            guard response.status.kind == .successful else {
                throw APIError.responseError(statusCode: response.status.code, reasonPhrase: response.status.reasonPhrase)
            }
            return (data, response)
        } catch {
            if error is APIError {
                throw error
            } else {
                throw APIError.httpTypeConversionError
            }
        }
    }
}

// MARK: - APIQuota

/// How many requests you have left in your monthly quota.
public struct APIQuota {
    /// Your total request limit for the monthly period.
    public let requestLimit: Int

    /// How many of these requests remain.
    public let requestRemaining: Int

    /// When the currently monthly period will roll over.
    public let resetTime: Date

    init?(headerFields: HTTPTypes.HTTPFields) {
        guard let xRatelimitLimit = headerFields[.xRatelimitLimit],
              let requestLimit = Int(xRatelimitLimit),
              let xRatelimitRemaining = headerFields[.xRatelimitRemaining],
              let requestRemaining = Int(xRatelimitRemaining),
              let xRatelimitReset = headerFields[.xRatelimitReset],
              let timestamp = Double(xRatelimitReset) else {
            return nil
        }
        self.requestLimit = requestLimit
        self.requestRemaining = requestRemaining
        self.resetTime = Date(timeIntervalSince1970: timestamp)
    }
}

// MARK: - APIError

public enum APIError: LocalizedError, Equatable {
    case httpTypeConversionError
    case responseError(statusCode: Int, reasonPhrase: String)
    case decodingError(localizedDescription: String)

    public var errorDescription: String? {
        switch self {
        case .httpTypeConversionError:
            LocalizedString("The operation couldn’t be completed. (HTTPTypesFoundation.HTTPTypeConversionError)", bundle: Bundle.module, comment: "API error")
        case .responseError(let statusCode, let reasonPhrase):
            "\(statusCode) \(reasonPhrase)"
        case .decodingError(let localizedDescription):
            localizedDescription
        }
    }

    // Equatable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.errorDescription == rhs.errorDescription
    }
}

// MARK: - Protocols

public protocol APIRequestSession {
    func data(for request: HTTPRequest) async throws -> (Data, HTTPTypes.HTTPResponse)
}

// `HTTPTypesFoundation` implements
// `func data(for request: HTTPRequest) async throws -> (Data, HTTPTypes.HTTPResponse)`
extension URLSession: APIRequestSession {}
