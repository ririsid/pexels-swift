import Foundation

/// The `Photos` object.
public struct Photos: Decodable, Equatable, Pageable {
    /// An array of `Photo` objects.
    public let photos: [Photo]
    
    /// The current page number.
    public let page: Int
    
    /// The number of results returned with each page.
    public let perPage: Int
    
    /// The total number of results for the request.
    public let totalResults: Int
    
    let previousPageURL: URL?
    let nextPageURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case photos
        case page
        case perPage = "per_page"
        case totalResults = "total_results"
        case previousPageURL = "prev_page"
        case nextPageURL = "next_page"
    }
}
