import XCTest
@testable import Pexels

final class ModelMediaTests: XCTestCase {
    var apiKey: String!
    var configuration: APIConfiguration!

    override func setUp() async throws {
        self.apiKey = try XCTUnwrap(TestingUtility.getPexelsAPIKey())
        self.configuration = APIConfiguration(with: apiKey)
    }
    
    func testMedia() async throws {
        let mediaData = try XCTUnwrap(TestingUtility.dataFromJSON(forResource: "collection_media"))
        let stubSession = StubResponseAPIRequestSession(data: mediaData)
        var provider = APIProvider(configuration: configuration, session: stubSession)
        var request = try APIEndpoint.Collections.media(id: "9j7p6tj")
        let media = try await provider.request(&request)

        XCTAssertEqual(media.media[0].type, .photo)
        let photoMediaExpectation = XCTestExpectation(description: "If the type is photo, the media must also be photo.")
        if case .photo = media.media[0].media {
            photoMediaExpectation.fulfill()
        }
        XCTAssertEqual(media.media[1].type, .video)
        let videoMediaExpectation = XCTestExpectation(description: "If the type is video, the media must also be video.")
        if case .video = media.media[1].media {
            videoMediaExpectation.fulfill()
        }
        await fulfillment(of: [photoMediaExpectation, videoMediaExpectation], timeout: .leastNonzeroMagnitude)
    }
}
