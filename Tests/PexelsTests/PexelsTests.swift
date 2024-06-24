import XCTest
@testable import Pexels

final class PexelsTests: XCTestCase {
    var apiKey: String!

    override func setUp() async throws {
        self.apiKey = try XCTUnwrap(TestingUtility.getPexelsAPIKey())
    }

    func testAPIKeyExists() {
        XCTAssertNotNil(apiKey)
    }

    func testDataFromJSON() {
        let emptyData = TestingUtility.dataFromJSON(forResource: "Empty")
        let noFileData = TestingUtility.dataFromJSON(forResource: "No file")

        XCTAssertNotNil(emptyData)
        XCTAssertNil(noFileData)
    }
}
