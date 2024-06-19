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
        let emptyJSONData = TestingUtility.dataFromJSON(forResource: "Empty")
        let noFileData = TestingUtility.dataFromJSON(forResource: "No file")

        XCTAssertNotNil(emptyJSONData)
        XCTAssertNil(noFileData)
    }
}
