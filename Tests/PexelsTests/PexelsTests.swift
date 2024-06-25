import XCTest
@testable import Pexels
import HTTPTypes

final class PexelsTests: XCTestCase {
    var apiKey: String!
    var configuration: APIConfiguration!

    override func setUp() async throws {
        self.apiKey = try XCTUnwrap(TestingUtility.getPexelsAPIKey())
        self.configuration = APIConfiguration(with: apiKey)
    }

    func testAPIKeyExists() {
        XCTAssertNotNil(apiKey)
    }

    func testDataFromJSON() {
        let emptyData = TestingUtility.dataFromJSON(forResource: "empty")
        let noFileData = TestingUtility.dataFromJSON(forResource: "no_file")

        XCTAssertNotNil(emptyData)
        XCTAssertNil(noFileData)
    }

    func testUpdatingAPIRequest() async throws {
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

// MARK: - Stub

private struct StubResponseAPIRequestSession: APIRequestSession {
    let data: Data
    let status: HTTPTypes.HTTPResponse.Status

    init(data: Data, status: HTTPTypes.HTTPResponse.Status = .ok) {
        self.data = data
        self.status = status
    }

    func data(for request: HTTPTypes.HTTPRequest) async throws -> (Data, HTTPTypes.HTTPResponse) {
        return (data, HTTPTypes.HTTPResponse(status: status))
    }
}

private struct StubAPIConfiguration: APIConfigurable {
    let apiKey: String
    let scheme: String?
    let authority: String?
}
