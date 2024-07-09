import Foundation
import struct HTTPTypes.HTTPRequest

extension APIEndpoint.Photos {
    private enum Path {
        static let search: String = "/v1/search"
        static let curated: String = "/v1/curated"
        static func photo(id: Int) -> String {
            return "/v1/photos/\(id)"
        }
    }

    /// This endpoint enables you to search Pexels for any topic that you would like. For example your query could be something broad like `Nature`, `Tigers`, `People`. Or it could be something specific like `Group of people working`.
    ///
    /// - Parameters:
    ///   - query: The search query. `Ocean`, `Tigers`, `Pears`, etc.
    ///   - orientation: Desired photo orientation. The current supported orientations are: `landscape`, `portrait` or `square`.
    ///   - size: Minimum photo size. The current supported sizes are: `large`(24MP), `medium`(12MP) or `small`(4MP).
    ///   - color: Desired photo color. Supported colors: `red`, `orange`, `yellow`, `green`, `turquoise`, `blue`, `violet`, `pink`, `brown`, `black`, `gray`, `white` or any hexadecimal color code (eg. `#ffffff`).
    ///   - locale: The locale of the search you are performing. The current supported locales are: `'en-US'` `'pt-BR'` `'es-ES'` `'ca-ES'` `'de-DE'` `'it-IT'` `'fr-FR'` `'sv-SE'` `'id-ID'` `'pl-PL'` `'ja-JP'` `'zh-TW'` `'zh-CN'` `'ko-KR'` `'th-TH'` `'nl-NL'` `'hu-HU'` `'vi-VN'` `'cs-CZ'` `'da-DK'` `'fi-FI'` `'uk-UA'` `'el-GR'` `'ro-RO'` `'nb-NO'` `'sk-SK'` `'tr-TR'` `'ru-RU'`.
    ///   - page: The page number you are requesting. `Default: 1`
    ///   - perPage: The number of results you are requesting per page. `Default: 15` `Max: 80`
    /// - Returns: A request to retrieve photos.
    public static func search(query: String, orientation: APIParameterTypes.Orientation? = nil, size: APIParameterTypes.Size? = nil, color: APIParameterTypes.Color? = nil, locale: APIParameterTypes.Locale? = nil, page: Int? = nil, perPage: Int? = nil) throws -> APIRequest<Photos> {
        // The `query` is required.
        guard let query = APIParameterTypes.Query(query) else {
            throw APIEndpointError.missingRequiredParameter(name: "query")
        }
        let page = APIParameterTypes.Page(page)
        let perPage = APIParameterTypes.PerPage(perPage)
        let parameters = Array<APIParameterable?>(arrayLiteral: query, orientation, size, color, locale, page, perPage)
        return APIRequest(method: .get, path: Path.search, parameters: parameters)
    }

    /// This endpoint enables you to receive real-time photos curated by the Pexels team.
    ///
    /// We add at least one new photo per hour to our curated list so that you always get a changing selection of trending photos.
    ///
    /// - Parameters:
    ///   - page: The page number you are requesting. `Default: 1`
    ///   - perPage: The number of results you are requesting per page. `Default: 15` `Max: 80`
    /// - Returns: A request to retrieve photos.
    public static func curated(page: Int? = nil, perPage: Int? = nil) throws -> APIRequest<Photos> {
        let page = APIParameterTypes.Page(page)
        let perPage = APIParameterTypes.PerPage(perPage)
        let parameters = Array<APIParameterable?>(arrayLiteral: page, perPage)
        return APIRequest(method: .get, path: Path.curated, parameters: parameters)
    }

    /// Retrieve a specific `Photo` from its id.
    ///
    /// - Parameters:
    ///   - id: The id of the photo you are requesting.
    /// - Returns: A request to retrieve photo.
    public static func photo(id: Int) throws -> APIRequest<Photo> {
        return APIRequest(method: .get, path: Path.photo(id: id))
    }

    /// This endpoint returns all photos by the page URL in the response.
    ///
    /// - Parameters:
    ///   - pageURL: The page URL in the response.
    /// - Returns: A request to retrieve photos.
    public static func page(url: URL) -> APIRequest<Photos> {
        return APIRequest(method: .get, url: url)
    }
}
