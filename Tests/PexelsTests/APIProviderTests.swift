import XCTest
@testable import Pexels
import HTTPTypes

final class APIProviderTests: XCTestCase {
    var apiKey: String!
    var configuration: APIConfiguration!

    override func setUp() async throws {
        self.apiKey = try XCTUnwrap(TestingUtility.getPexelsAPIKey())
        self.configuration = APIConfiguration(with: apiKey)
    }

    func testAPIRequestUpdatesThroughConfiguration() async throws {
        let photosData = try XCTUnwrap(TestingUtility.dataFromJSON(forResource: "photos"))
        let stubSession = StubResponseAPIRequestSession(data: photosData)
        var provider = APIProvider(configuration: configuration, session: stubSession)
        var request = try APIEndpoint.Photos.search(query: "nature")
        let _ = try await provider.request(&request)

        XCTAssertEqual(request.scheme, configuration.scheme)
        XCTAssertEqual(request.authority, configuration.authority)
        XCTAssertEqual(request.headerFields[.authorization], configuration.apiKey)
        XCTAssertEqual(request.headerFields[.accept], "application/json")
        XCTAssertEqual(request.headerFields[.contentType], "application/json")
    }

    func testAPISuccess() async throws {
        let photosData = try XCTUnwrap(TestingUtility.dataFromJSON(forResource: "photos"))
        let stubSession = StubResponseAPIRequestSession(data: photosData)
        var provider = APIProvider(configuration: configuration, session: stubSession)
        var request = try APIEndpoint.Photos.search(query: "nature")
        let photos = try await provider.request(&request)

        XCTAssertEqual(photos.page, 1)
    }

    func testAPIErrorHTTPTypeConversionError() async throws {
        let configuration = StubAPIConfiguration(apiKey: apiKey, scheme: nil, authority: nil)
        var provider = APIProvider(configuration: configuration)
        var request = try APIEndpoint.Photos.search(query: "nature")
        do {
            let _ = try await provider.request(&request)
        } catch {
            let error = try XCTUnwrap(error as? APIError)
            XCTAssertEqual(error, APIError.httpTypeConversionError)
        }
    }

    func testAPIErrorResponseError() async throws {
        let stubSession = StubResponseAPIRequestSession(data: Data(), status: .notFound)
        var provider = APIProvider(configuration: configuration, session: stubSession)
        var request = try APIEndpoint.Photos.search(query: "nature")
        do {
            let _ = try await provider.request(&request)
        } catch {
            let error = try XCTUnwrap(error as? APIError)
            XCTAssertEqual(error, APIError.responseError(statusCode: 404, reasonPhrase: "Not Found"))
        }
    }

    func testAPIErrorDecodingError() async throws {
        let emptyData = try XCTUnwrap(TestingUtility.dataFromJSON(forResource: "empty"))
        let stubSession = StubResponseAPIRequestSession(data: emptyData)
        var provider = APIProvider(configuration: configuration, session: stubSession)
        var request = try APIEndpoint.Photos.search(query: "nature")
        do {
            let _ = try await provider.request(&request)
        } catch {
            let error = try XCTUnwrap(error as? APIError)
            XCTAssertEqual(error, APIError.decodingError(localizedDescription: error.localizedDescription))
        }
    }
}

// MARK: - Pagination

final class APIPaginationTests: XCTestCase {
    var apiKey: String!
    var configuration: APIConfiguration!

    override func setUp() async throws {
        self.apiKey = try XCTUnwrap(TestingUtility.getPexelsAPIKey())
        self.configuration = APIConfiguration(with: apiKey)
    }

    func testPreviousPage() async throws {
        let photosData = try XCTUnwrap(TestingUtility.dataFromJSON(forResource: "photos_second_page"))
        let stubSession = StubResponseAPIRequestSession(data: photosData)
        var provider = APIProvider(configuration: configuration, session: stubSession)
        var request = try APIEndpoint.Photos.search(query: "nature")
        let photos = try await provider.request(&request)

        XCTAssertEqual(photos.previousPage, 1)
    }

    func testNoPreviousPage() async throws {
        let photosData = try XCTUnwrap(TestingUtility.dataFromJSON(forResource: "photos"))
        let stubSession = StubResponseAPIRequestSession(data: photosData)
        var provider = APIProvider(configuration: configuration, session: stubSession)
        var request = try APIEndpoint.Photos.search(query: "nature")
        let photos = try await provider.request(&request)

        XCTAssertNil(photos.previousPage)
    }

    func testNextPage() async throws {
        let photosData = try XCTUnwrap(TestingUtility.dataFromJSON(forResource: "photos"))
        let stubSession = StubResponseAPIRequestSession(data: photosData)
        var provider = APIProvider(configuration: configuration, session: stubSession)
        var request = try APIEndpoint.Photos.search(query: "nature")
        let photos = try await provider.request(&request)

        XCTAssertEqual(photos.nextPage, 2)
    }

    func testNoNextPage() async throws {
        let photosData = try XCTUnwrap(TestingUtility.dataFromJSON(forResource: "photos_last_page"))
        let stubSession = StubResponseAPIRequestSession(data: photosData)
        var provider = APIProvider(configuration: configuration, session: stubSession)
        var request = try APIEndpoint.Photos.search(query: "nature")
        let photos = try await provider.request(&request)

        XCTAssertNil(photos.nextPage)
    }
}

// MARK: - APIQuota

final class APIQuotaTests: XCTestCase {
    var apiKey: String!
    var configuration: APIConfiguration!

    override func setUp() async throws {
        self.apiKey = try XCTUnwrap(TestingUtility.getPexelsAPIKey())
        self.configuration = APIConfiguration(with: apiKey)
    }

    func testQuotaRemaining() async throws {
        let photosData = try XCTUnwrap(TestingUtility.dataFromJSON(forResource: "photos"))
        let headerFields = HTTPTypes.HTTPFields([
            .init(name: .xRatelimitLimit, value: "25000"),
            .init(name: .xRatelimitRemaining, value: "24999"),
            .init(name: .xRatelimitReset, value: String(Date.now.timeIntervalSince1970 + 1))
        ])
        let stubSession = StubResponseAPIRequestSession(data: photosData, headerFields: headerFields)
        var provider = APIProvider(configuration: configuration, session: stubSession)
        var request = try APIEndpoint.Photos.search(query: "nature")
        let _ = try await provider.request(&request)

        let quota = try XCTUnwrap(provider.quota)
        XCTAssertGreaterThan(quota.requestLimit, 0)
        XCTAssertGreaterThanOrEqual(quota.requestRemaining, 0)
        XCTAssertGreaterThan(quota.resetTime, Date.now)
    }

    func testQuotaExceeded() async throws {
        let photosData = try XCTUnwrap(TestingUtility.dataFromJSON(forResource: "photos"))
        let stubSession = StubResponseAPIRequestSession(data: photosData, status: .tooManyRequests)
        var provider = APIProvider(configuration: configuration, session: stubSession)
        var request = try APIEndpoint.Photos.search(query: "nature")
        let _ = try? await provider.request(&request)

        XCTAssertNil(provider.quota)
    }
}

// MARK: - Middleware

final class MiddlewareTests: XCTestCase {
    var apiKey: String!
    var configuration: APIConfiguration!

    override func setUp() async throws {
        self.apiKey = try XCTUnwrap(TestingUtility.getPexelsAPIKey())
        self.configuration = APIConfiguration(with: apiKey)
    }

    func testMiddleware() async throws {
        let photosData = try XCTUnwrap(TestingUtility.dataFromJSON(forResource: "photos"))
        let stubSession = StubResponseAPIRequestSession(data: photosData)
        var provider = APIProvider(configuration: configuration, session: stubSession)
        provider.middleware.use(TestingMiddleware())
        var request = try APIEndpoint.Photos.search(query: "nature")
        let photos = try await provider.request(&request)

        XCTAssertEqual(photos.page, 1)
    }
}

private struct TestingMiddleware: Middleware {
    func respond(to request: HTTPTypes.HTTPRequest, chainingTo next: Responder) async throws -> (Data, HTTPTypes.HTTPResponse) {
        print("Start a request: \(request.url!)")
        let (data, response) = try await next.respond(to: request)
        print("Received a response: \(response.status)")
        return (data, response)
    }
}
