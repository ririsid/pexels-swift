import Foundation

public struct Photos: Decodable, Equatable {
    /// An array of `Photo` objects.
    public let photos: [Photo]
    
    /// The current page number.
    public let page: Int
    
    /// The number of results returned with each page.
    public let perPage: Int
    
    /// The total number of results for the request.
    public let totalResults: Int
    
    /// URL for the previous page of results, if applicable.
    public let previousPage: URL?
    
    /// URL for the next page of results, if applicable.
    public let nextPage: URL?
    
    enum CodingKeys: String, CodingKey {
        case photos
        case page
        case perPage = "per_page"
        case totalResults = "total_results"
        case previousPage = "prev_page"
        case nextPage = "next_page"
    }
}
