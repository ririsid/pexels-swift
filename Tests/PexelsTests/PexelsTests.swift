import XCTest
@testable import Pexels

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
}
