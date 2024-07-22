import Foundation

/// The `Videos` object.
public struct Videos: Decodable, Equatable, Pageable {
    /// An array of `Video` objects.
    public let videos: [Video]

    /// The Pexels URL for the current search query.
    public let url: URL

    public let page: Int
    public let perPage: Int
    public let totalResults: Int

    public let previousPageURL: URL?
    public let nextPageURL: URL?

    enum CodingKeys: String, CodingKey {
        case videos
        case url
        case page
        case perPage = "per_page"
        case totalResults = "total_results"
        case previousPageURL = "prev_page"
        case nextPageURL = "next_page"
    }
}
