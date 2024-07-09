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
        let photosData = try XCTUnwrap(TestingUtility.dataFromJSON(forResource: "photos_last_page"))
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

    func testPhotosPageRequest() async throws {
        let photosData = try XCTUnwrap(TestingUtility.dataFromJSON(forResource: "photos_second_page"))
        let stubSession = StubResponseAPIRequestSession(data: photosData)
        var provider = APIProvider(configuration: configuration, session: stubSession)
        var request = try APIEndpoint.Photos.search(query: "nature", page: 2, perPage: 1)
        let photos = try await provider.request(&request)
        let previousPageRequest = APIEndpoint.Photos.page(url: photos.previousPageURL!)
        let nextPageRequest = APIEndpoint.Photos.page(url: photos.nextPageURL!)

        XCTAssertEqual(previousPageRequest.path, "/v1/search/?page=1&per_page=1&query=nature")
        XCTAssertEqual(nextPageRequest.path, "/v1/search/?page=3&per_page=1&query=nature")
    }

    func testVideosPageRequest() async throws {
        let videosData = try XCTUnwrap(TestingUtility.dataFromJSON(forResource: "videos_second_page"))
        let stubSession = StubResponseAPIRequestSession(data: videosData)
        var provider = APIProvider(configuration: configuration, session: stubSession)
        var request = try APIEndpoint.Videos.search(query: "nature", page: 2, perPage: 1)
        let videos = try await provider.request(&request)
        let previousPageRequest = APIEndpoint.Videos.page(url: videos.previousPageURL!)
        let nextPageRequest = APIEndpoint.Videos.page(url: videos.nextPageURL!)

        XCTAssertEqual(previousPageRequest.path, "/v1/videos/search/?page=1&per_page=1&query=nature")
        XCTAssertEqual(nextPageRequest.path, "/v1/videos/search/?page=3&per_page=1&query=nature")
    }

    func testCollectionsPageRequest() async throws {
        let collectionsData = try XCTUnwrap(TestingUtility.dataFromJSON(forResource: "collections_second_page"))
        let stubSession = StubResponseAPIRequestSession(data: collectionsData)
        var provider = APIProvider(configuration: configuration, session: stubSession)
        var request = try APIEndpoint.Collections.featured(page: 2, perPage: 1)
        let collections = try await provider.request(&request)
        let previousPageRequest = APIEndpoint.Collections.page(url: collections.previousPageURL!)
        let nextPageRequest = APIEndpoint.Collections.page(url: collections.nextPageURL!)

        XCTAssertEqual(previousPageRequest.path, "/v1/collections/featured/?page=1&per_page=1")
        XCTAssertEqual(nextPageRequest.path, "/v1/collections/featured/?page=3&per_page=1")
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
