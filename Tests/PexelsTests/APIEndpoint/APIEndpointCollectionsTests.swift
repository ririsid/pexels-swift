import XCTest
@testable import Pexels

final class APIEndpointCollectionsTests: XCTestCase {
    func testFeaturedCollections() throws {
        let request = try APIEndpoint.Collections.featured(page: 1, perPage: 15)

        XCTAssertEqual(request.method, .get)
        XCTAssertEqual(request.path, "/v1/collections/featured?page=1&per_page=15")
    }

    func testMyCollections() throws {
        let request = try APIEndpoint.Collections.my(page: 1, perPage: 15)

        XCTAssertEqual(request.method, .get)
        XCTAssertEqual(request.path, "/v1/collections?page=1&per_page=15")
    }

    func testCollectionMedia() throws {
        let request = try APIEndpoint.Collections.media(id: "9j7p6tj", type: .photos, sort: .ascending, page: 1, perPage: 15)

        XCTAssertEqual(request.method, .get)
        XCTAssertEqual(request.path, "/v1/collections/9j7p6tj?type=photos&sort=asc&page=1&per_page=15")
    }
}
