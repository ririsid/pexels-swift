import Foundation

/// The `Videos` object.
public struct Videos: Decodable, Equatable, Pageable {
    /// An array of `Video` objects.
    public let videos: [Video]

    /// The Pexels URL for the current search query.
    public let url: URL

    /// The current page number.
    public let page: Int

    /// The number of results returned with each page.
    public let perPage: Int

    /// The total number of results for the request.
    public let totalResults: Int

    let previousPageURL: URL?
    let nextPageURL: URL?

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
