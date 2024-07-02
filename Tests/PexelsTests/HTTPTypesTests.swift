import XCTest
import struct HTTPTypes.HTTPRequest

final class HTTPTypesTests: XCTestCase {
    func testHTTPRequestWithQueryItems() {
        let requestWithQueryItems = HTTPRequest(method: .get, scheme: nil, authority: nil, path: "/search", queryItems: [URLQueryItem(name: "query", value: "nature")])
        let requestWithNoQueryItems = HTTPRequest(method: .get, scheme: nil, authority: nil, path: "/", queryItems: nil)
        let requestWithEmptyQueryItems = HTTPRequest(method: .get, scheme: nil, authority: nil, path: "/", queryItems: [])
        let requestWithNoValueQueryItem = HTTPRequest(method: .get, scheme: nil, authority: nil, path: "/", queryItems: [URLQueryItem(name: "no_value", value: nil)])
        let requestWithNoPath = HTTPRequest(method: .get, scheme: nil, authority: nil, path: nil, queryItems: [URLQueryItem(name: "query", value: "nature")])

        XCTAssertEqual(requestWithQueryItems.method, .get)
        XCTAssertEqual(requestWithQueryItems.path, "/search?query=nature")
        XCTAssertEqual(requestWithNoQueryItems.method, .get)
        XCTAssertEqual(requestWithNoQueryItems.path, "/")
        XCTAssertEqual(requestWithEmptyQueryItems.method, .get)
        XCTAssertEqual(requestWithEmptyQueryItems.path, "/")
        XCTAssertEqual(requestWithNoValueQueryItem.method, .get)
        XCTAssertEqual(requestWithNoValueQueryItem.path, "/")
        XCTAssertEqual(requestWithNoPath.method, .get)
        XCTAssertEqual(requestWithNoPath.path, "?query=nature")
    }
}
