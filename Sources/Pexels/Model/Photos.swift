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
    public var previousPage: Int? {
        guard let url = previousPageURL,
              let value = url.queryParameterValue(for: "page"),
              let page = Int(value) else { return nil }
        return page
    }
    
    /// URL for the next page of results, if applicable.
    public var nextPage: Int? {
        guard let url = nextPageURL,
              let value = url.queryParameterValue(for: "page"),
              let page = Int(value) else { return nil }
        return page
    }
    
    /// URL for the previous page of results, if applicable.
    private let previousPageURL: URL?
    
    /// URL for the next page of results, if applicable.
    private let nextPageURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case photos
        case page
        case perPage = "per_page"
        case totalResults = "total_results"
        case previousPageURL = "prev_page"
        case nextPageURL = "next_page"
    }
}
