import XCTest
@testable import Pexels
import struct HTTPTypes.HTTPRequest

final class APIEndpointTests: XCTestCase {
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
