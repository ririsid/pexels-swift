import Foundation
import struct HTTPTypes.HTTPRequest

extension APIEndpoint.Videos {
    private enum Path: String {
        case search = "/videos/search"
        case popular = "/videos/popular"
        case video = "/videos/videos"
    }

    /// This endpoint enables you to search Pexels for any topic that you would like. For example your query could be something broad like `Nature`, `Tigers`, `People`. Or it could be something specific like `Group of people working`.
    ///
    /// - Parameters:
    ///   - query: The search query. `Ocean`, `Tigers`, `Pears`, etc.
    ///   - orientation: Desired photo orientation. The current supported orientations are: `landscape`, `portrait` or `square`.
    ///   - size: Minimum video size. The current supported sizes are: `large`(4K), `medium`(Full HD) or `small`(HD).
    ///   - locale: The locale of the search you are performing. The current supported locales are: `'en-US'` `'pt-BR'` `'es-ES'` `'ca-ES'` `'de-DE'` `'it-IT'` `'fr-FR'` `'sv-SE'` `'id-ID'` `'pl-PL'` `'ja-JP'` `'zh-TW'` `'zh-CN'` `'ko-KR'` `'th-TH'` `'nl-NL'` `'hu-HU'` `'vi-VN'` `'cs-CZ'` `'da-DK'` `'fi-FI'` `'uk-UA'` `'el-GR'` `'ro-RO'` `'nb-NO'` `'sk-SK'` `'tr-TR'` `'ru-RU'`.
    ///   - page: The page number you are requesting. `Default: 1`
    ///   - perPage: The number of results you are requesting per page. `Default: 15` `Max: 80`
    /// - Returns: A request to retrieve photos.
    public static func search(query: String, orientation: APIParameterTypes.Orientation? = nil, size: APIParameterTypes.Size? = nil, locale: APIParameterTypes.Locale? = nil, page: Int? = nil, perPage: Int? = nil) throws -> APIRequest<Videos> {
        // The `query` is required.
        guard let query = APIParameterTypes.Query(query) else {
            throw APIEndpointError.missingRequiredParameter(name: "query")
        }
        let page = APIParameterTypes.Page(page)
        let perPage = APIParameterTypes.PerPage(perPage)
        let parameters = Array<APIParameterable?>(arrayLiteral: query, orientation, size, locale, page, perPage)
        return APIRequest(method: .get, path: Path.search.rawValue, parameters: parameters)
    }

    /// This endpoint enables you to receive the current popular Pexels videos.
    ///
    /// - Parameters:
    ///   - minWidth: The minimum width in pixels of the returned videos.
    ///   - minHeight: The minimum height in pixels of the returned videos.
    ///   - minDuration: The minimum duration in seconds of the returned videos.
    ///   - maxDuration: The maximum duration in seconds of the returned videos.
    ///   - page: The page number you are requesting. `Default: 1`
    ///   - perPage: The number of results you are requesting per page. `Default: 15` `Max: 80`
    /// - Returns: A request to retrieve photos.
    public static func popular(minWidth: Int? = nil, minHeight: Int? = nil, minDuration: Int? = nil, maxDuration: Int? = nil, page: Int? = nil, perPage: Int? = nil) throws -> APIRequest<Videos> {
        let minWidth = APIParameterTypes.MinWidth(minWidth)
        let minHeight = APIParameterTypes.MinHeight(minHeight)
        let minDuration = APIParameterTypes.MinDuration(minDuration)
        let maxDuration = APIParameterTypes.MaxDuration(maxDuration)
        let page = APIParameterTypes.Page(page)
        let perPage = APIParameterTypes.PerPage(perPage)
        let parameters = Array<APIParameterable?>(arrayLiteral: minWidth, minHeight, minDuration, maxDuration, page, perPage)
        return APIRequest(method: .get, path: Path.popular.rawValue, parameters: parameters)
    }

    /// Retrieve a specific `Video` from its id.
    ///
    /// - Parameters:
    ///   - id: The id of the video you are requesting.
    /// - Returns: A request to retrieve video.
    public static func video(id: Int) throws -> APIRequest<Video> {
        let path = Path.video.rawValue + "/\(id)"
        return APIRequest(method: .get, path: path)
    }
}
