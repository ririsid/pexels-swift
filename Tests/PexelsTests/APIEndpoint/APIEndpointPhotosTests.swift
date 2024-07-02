import XCTest
@testable import Pexels

final class APIEndpointPhotosTests: XCTestCase {
    func testSearchPhotos() throws {
        let request = try APIEndpoint.Photos.search(query: "nature", orientation: .landscape, size: .large, color: .red, locale: .koKR, page: 1, perPage: 15)

        XCTAssert(request.method == .get)
        XCTAssert(request.path == "/v1/search?query=nature&orientation=landscape&size=large&color=red&locale=ko-KR&page=1&per_page=15")
    }

    func testSearchPhotosWithEmptyQuery() {
        XCTAssertThrowsError(try APIEndpoint.Photos.search(query: "")) { error in
            let error = try? XCTUnwrap(error as? APIEndpointError)
            XCTAssert(error == .missingRequiredParameter(name: "query"))
        }
    }

    func testCuratedPhotos() throws {
        let request = try APIEndpoint.Photos.curated(page: 1, perPage: 15)

        XCTAssert(request.method == .get)
        XCTAssert(request.path == "/v1/curated?page=1&per_page=15")
    }

    func testGetPhoto() throws {
        let request = try APIEndpoint.Photos.photo(id: 2014422)

        XCTAssert(request.method == .get)
        XCTAssert(request.path == "/v1/photos/2014422")
    }
}
