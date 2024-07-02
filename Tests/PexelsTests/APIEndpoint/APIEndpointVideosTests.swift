import XCTest
@testable import Pexels

final class APIEndpointVideosTests: XCTestCase {
    func testSearchVideos() throws {
        let request = try APIEndpoint.Videos.search(query: "nature", orientation: .landscape, size: .large, locale: .koKR, page: 1, perPage: 15)

        XCTAssert(request.method == .get)
        XCTAssert(request.path == "/videos/search?query=nature&orientation=landscape&size=large&locale=ko-KR&page=1&per_page=15")
    }

    func testSearchVideosWithEmptyQuery() {
        XCTAssertThrowsError(try APIEndpoint.Videos.search(query: "")) { error in
            let error = try? XCTUnwrap(error as? APIEndpointError)
            XCTAssert(error == .missingRequiredParameter(name: "query"))
        }
    }

    func testPopularVideos() throws {
        let request = try APIEndpoint.Videos.popular(minWidth: 1024, minHeight: 1024, minDuration: 1, maxDuration: 60, page: 1, perPage: 15)

        XCTAssert(request.method == .get)
        XCTAssert(request.path == "/videos/popular?min_width=1024&min_height=1024&min_duration=1&max_duration=60&page=1&per_page=15")
    }

    func testGetVideo() throws {
        let request = try APIEndpoint.Videos.video(id: 2499611)

        XCTAssert(request.method == .get)
        XCTAssert(request.path == "/videos/videos/2499611")
    }
}
