import Foundation
import struct HTTPTypes.HTTPRequest

extension APIEndpoint.Collections {
    private enum Path {
        static let featured: String = "/v1/collections/featured"
        static let my: String = "/v1/collections"
        static func media(id: String) -> String {
            return "/v1/collections/\(id)"
        }
    }

    /// This endpoint returns all featured collections on Pexels.
    ///
    /// - Parameters:
    ///   - page: The page number you are requesting. `Default: 1`
    ///   - perPage: The number of results you are requesting per page. `Default: 15` `Max: 80`
    /// - Returns: A request to retrieve collections.
    public static func featured(page: Int? = nil, perPage: Int? = nil) throws -> APIRequest<Collections> {
        let page = APIParameterTypes.Page(page)
        let perPage = APIParameterTypes.PerPage(perPage)
        let parameters = Array<APIParameterable?>(arrayLiteral: page, perPage)
        return APIRequest(method: .get, path: Path.featured, parameters: parameters)
    }

    /// This endpoint returns all of your collections.
    ///
    /// - Parameters:
    ///   - page: The page number you are requesting. `Default: 1`
    ///   - perPage: The number of results you are requesting per page. `Default: 15` `Max: 80`
    /// - Returns: A request to retrieve collections.
    public static func my(page: Int? = nil, perPage: Int? = nil) throws -> APIRequest<Collections> {
        let page = APIParameterTypes.Page(page)
        let perPage = APIParameterTypes.PerPage(perPage)
        let parameters = Array<APIParameterable?>(arrayLiteral: page, perPage)
        return APIRequest(method: .get, path: Path.my, parameters: parameters)
    }

    /// This endpoint returns all the media (photos and videos) within a single collection. You can filter to only receive photos or videos using the `type` parameter.
    ///
    /// - Parameters:
    ///   - id: The id of the video you are requesting.
    ///   - sort: The order of items in the media collection. Supported values are: `asc`, `desc`. `Default: asc`
    ///   - page: The page number you are requesting. `Default: 1`
    ///   - perPage: The number of results you are requesting per page. `Default: 15` `Max: 80`
    /// - Returns: A request to retrieve video.
    public static func media(id: String, type: APIParameterTypes.MediaType? = nil, sort: APIParameterTypes.Sort? = nil, page: Int? = nil, perPage: Int? = nil) throws -> APIRequest<CollectionMedia> {
        let page = APIParameterTypes.Page(page)
        let perPage = APIParameterTypes.PerPage(perPage)
        let parameters = Array<APIParameterable?>(arrayLiteral: type, sort, page, perPage)
        return APIRequest(method: .get, path: Path.media(id: id), parameters: parameters)
    }
}
