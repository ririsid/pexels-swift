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
}
