import Foundation

public protocol Pageable {
    /// The current page number.
    var page: Int { get }

    /// The number of results returned with each page.
    var perPage: Int { get }

    /// The total number of results for the request.
    var totalResults: Int { get }

    /// URL for the previous page of results, if applicable.
    var previousPageURL: URL? { get }

    /// URL for the next page of results, if applicable.
    var nextPageURL: URL? { get }
}

extension Pageable {
    /// URL for the previous page of results, if applicable.
    public var previousPage: Int? {
        guard let url = previousPageURL,
              let page = getPage(from: url) else { return nil }
        return page
    }

    /// URL for the next page of results, if applicable.
    public var nextPage: Int? {
        guard let url = nextPageURL,
              let page = getPage(from: url) else { return nil }
        return page
    }

    /// Get the page value from the URL.
    ///
    /// - Parameter url: The URL.
    /// - Returns: The page value.
    private func getPage(from url: URL) -> Int? {
        guard let value = url.queryParameterValue(for: APIParameterTypes.Page.name),
            let page = Int(value) else { return nil }
        return page
    }
}
