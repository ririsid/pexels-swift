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
        let provider = APIProvider(configuration: configuration, session: stubSession)
        var request = try APIEndpoint.Photos.search(query: "nature")
        let _ = try await provider.request(&request)

        XCTAssert(request.scheme == configuration.scheme)
        XCTAssert(request.authority == configuration.authority)
        XCTAssert(request.headerFields[.authorization] == configuration.apiKey)
    }

    func testAPISuccess() async throws {
        let photosData = try XCTUnwrap(TestingUtility.dataFromJSON(forResource: "photos"))
        let stubSession = StubResponseAPIRequestSession(data: photosData)
        let provider = APIProvider(configuration: configuration, session: stubSession)
        var request = try APIEndpoint.Photos.search(query: "nature")
        let photos = try await provider.request(&request)

        XCTAssert(photos.page == 1)
    }

    func testAPIErrorHTTPTypeConversionError() async throws {
        let configuration = StubAPIConfiguration(apiKey: apiKey, scheme: nil, authority: nil)
        let provider = APIProvider(configuration: configuration)
        var request = try APIEndpoint.Photos.search(query: "nature")
        do {
            let _ = try await provider.request(&request)
        } catch {
            let error = try XCTUnwrap(error as? APIError)
            XCTAssert(error == APIError.httpTypeConversionError)
        }
    }

    func testAPIErrorResponseError() async throws {
        let stubSession = StubResponseAPIRequestSession(data: Data(), status: .notFound)
        let provider = APIProvider(configuration: configuration, session: stubSession)
        var request = try APIEndpoint.Photos.search(query: "nature")
        do {
            let _ = try await provider.request(&request)
        } catch {
            let error = try XCTUnwrap(error as? APIError)
            XCTAssert(error == APIError.responseError(statusCode: 404, reasonPhrase: "Not Found"))
        }
    }

    func testAPIErrorDecodingError() async throws {
        let emptyData = try XCTUnwrap(TestingUtility.dataFromJSON(forResource: "empty"))
        let stubSession = StubResponseAPIRequestSession(data: emptyData)
        let provider = APIProvider(configuration: configuration, session: stubSession)
        var request = try APIEndpoint.Photos.search(query: "nature")
        do {
            let _ = try await provider.request(&request)
        } catch {
            let error = try XCTUnwrap(error as? APIError)
            XCTAssert(error == APIError.decodingError(localizedDescription: "The data couldn’t be read because it is missing."))
        }
    }
}

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
        let provider = APIProvider(configuration: configuration, session: stubSession)
        var request = try APIEndpoint.Photos.search(query: "nature")
        let photos = try await provider.request(&request)

        XCTAssert(photos.previousPage == 1)
    }

    func testNoPreviousPage() async throws {
        let photosData = try XCTUnwrap(TestingUtility.dataFromJSON(forResource: "photos"))
        let stubSession = StubResponseAPIRequestSession(data: photosData)
        let provider = APIProvider(configuration: configuration, session: stubSession)
        var request = try APIEndpoint.Photos.search(query: "nature")
        let photos = try await provider.request(&request)

        XCTAssertNil(photos.previousPage)
    }

    func testNextPage() async throws {
        let photosData = try XCTUnwrap(TestingUtility.dataFromJSON(forResource: "photos"))
        let stubSession = StubResponseAPIRequestSession(data: photosData)
        let provider = APIProvider(configuration: configuration, session: stubSession)
        var request = try APIEndpoint.Photos.search(query: "nature")
        let photos = try await provider.request(&request)

        XCTAssert(photos.nextPage == 2)
    }

    func testNoNextPage() async throws {
        let photosData = try XCTUnwrap(TestingUtility.dataFromJSON(forResource: "photos_last_page"))
        let stubSession = StubResponseAPIRequestSession(data: photosData)
        let provider = APIProvider(configuration: configuration, session: stubSession)
        var request = try APIEndpoint.Photos.search(query: "nature")
        let photos = try await provider.request(&request)

        XCTAssertNil(photos.nextPage)
    }
}

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
        let provider = APIProvider(configuration: configuration, session: stubSession)
        var request = try APIEndpoint.Photos.search(query: "nature")
        let _ = try await provider.request(&request)

        let quota = try XCTUnwrap(provider.quota)
        XCTAssert(quota.requestLimit > 0)
        XCTAssert(quota.requestRemaining >= 0)
        XCTAssert(quota.resetTime > Date.now)
    }

    func testQuotaExceeded() async throws {
        let photosData = try XCTUnwrap(TestingUtility.dataFromJSON(forResource: "photos"))
        let stubSession = StubResponseAPIRequestSession(data: photosData, status: .tooManyRequests)
        let provider = APIProvider(configuration: configuration, session: stubSession)
        var request = try APIEndpoint.Photos.search(query: "nature")
        let _ = try? await provider.request(&request)

        XCTAssertNil(provider.quota)
    }
}

// MARK: - Stub

private struct StubResponseAPIRequestSession: APIRequestSession {
    let data: Data
    let status: HTTPTypes.HTTPResponse.Status
    let headerFields: HTTPTypes.HTTPFields

    init(data: Data, status: HTTPTypes.HTTPResponse.Status = .ok, headerFields: HTTPTypes.HTTPFields = HTTPTypes.HTTPFields()) {
        self.data = data
        self.status = status
        self.headerFields = headerFields
    }

    func data(for request: HTTPTypes.HTTPRequest) async throws -> (Data, HTTPTypes.HTTPResponse) {
        return (data, HTTPTypes.HTTPResponse(status: status, headerFields: headerFields))
    }
}

private struct StubAPIConfiguration: APIConfigurable {
    let apiKey: String
    let scheme: String?
    let authority: String?
}
