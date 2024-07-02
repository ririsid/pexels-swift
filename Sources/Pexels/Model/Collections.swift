import Foundation

/// The `Collections` object.
public struct Collections: Decodable, Equatable, Pageable {
    /// An array of `Collection` objects.
    public let collections: [MediaCollection]

    public let page: Int
    public let perPage: Int
    public let totalResults: Int

    internal let previousPageURL: URL?
    internal let nextPageURL: URL?

    enum CodingKeys: String, CodingKey {
        case collections
        case page
        case perPage = "per_page"
        case totalResults = "total_results"
        case previousPageURL = "prev_page"
        case nextPageURL = "next_page"
    }
}
