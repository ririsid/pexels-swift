import XCTest
@testable import Pexels
import struct HTTPTypes.HTTPRequest

final class APIEndpointTests: XCTestCase {
    func testPhotosSearch() throws {
        let searchRequest = try APIEndpoint.Photos.search(query: "nature", orientation: .landscape, size: .large, color: .red, locale: .koKR, page: 1, perPage: 15)

        XCTAssert(searchRequest.method == .get)
        XCTAssert(searchRequest.path == "/v1/search?query=nature&orientation=landscape&size=large&color=red&locale=ko-KR&page=1&per_page=15")
    }

    func testPhotosSearchWithEmptyQuery() {
        XCTAssertThrowsError(try APIEndpoint.Photos.search(query: "")) { error in
            let error = try? XCTUnwrap(error as? APIEndpointError)
            XCTAssert(error == .missingRequiredParameter(name: "query"))
        }
    }
}

final class APIParameterTypes_APIEndpointTests: XCTestCase {
    func testPageWithNoValue() {
        XCTAssertNil(APIParameterTypes.Page(nil))
    }

    func testPerPageWithNoValue() {
        XCTAssertNil(APIParameterTypes.PerPage(nil))
    }
}

final class HTTPTypesTests: XCTestCase {
    func testHTTPRequestWithQueryItems() {
        let requestWithQueryItems = HTTPRequest(method: .get, scheme: nil, authority: nil, path: "/search", queryItems: [URLQueryItem(name: "query", value: "nature")])
        let requestWithNoQueryItems = HTTPRequest(method: .get, scheme: nil, authority: nil, path: "/", queryItems: nil)
        let requestWithEmptyQueryItems = HTTPRequest(method: .get, scheme: nil, authority: nil, path: "/", queryItems: [])
        let requestWithNoValueQueryItem = HTTPRequest(method: .get, scheme: nil, authority: nil, path: "/", queryItems: [URLQueryItem(name: "no_value", value: nil)])
        let requestWithNoPath = HTTPRequest(method: .get, scheme: nil, authority: nil, path: nil, queryItems: [URLQueryItem(name: "query", value: "nature")])

        XCTAssert(requestWithQueryItems.method == .get)
        XCTAssert(requestWithQueryItems.path == "/search?query=nature")
        XCTAssert(requestWithNoQueryItems.method == .get)
        XCTAssert(requestWithNoQueryItems.path == "/")
        XCTAssert(requestWithEmptyQueryItems.method == .get)
        XCTAssert(requestWithEmptyQueryItems.path == "/")
        XCTAssert(requestWithNoValueQueryItem.method == .get)
        XCTAssert(requestWithNoValueQueryItem.path == "/")
        XCTAssert(requestWithNoPath.method == .get)
        XCTAssert(requestWithNoPath.path == "?query=nature")
    }
}
