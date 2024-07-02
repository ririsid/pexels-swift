import Foundation

protocol Pageable {
    /// URL for the previous page of results, if applicable.
    var previousPageURL: URL? { get }

    /// URL for the next page of results, if applicable.
    var nextPageURL: URL? { get }
}

extension Pageable {
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
}
