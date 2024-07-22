import Foundation

/// The `Photos` object.
public struct Photos: Decodable, Equatable, Pageable {
    /// An array of `Photo` objects.
    public let photos: [Photo]

    public let page: Int
    public let perPage: Int
    public let totalResults: Int

    public let previousPageURL: URL?
    public let nextPageURL: URL?

    enum CodingKeys: String, CodingKey {
        case photos
        case page
        case perPage = "per_page"
        case totalResults = "total_results"
        case previousPageURL = "prev_page"
        case nextPageURL = "next_page"
    }
}
