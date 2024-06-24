import Foundation
import struct HTTPTypes.HTTPRequest

extension APIEndpoint.Photos {
    private enum Path: String {
        case search = "/v1/search"
    }

    ///  This endpoint enables you to search Pexels for any topic that you would like. For example your query could be something broad like `Nature`, `Tigers`, `People`. Or it could be something specific like `Group of people working`.
    ///
    /// - Parameters:
    ///   - query: The search query. `Ocean`, `Tigers`, `Pears`, etc.
    ///   - orientation: Desired photo orientation. The current supported orientations are: `landscape`, `portrait` or `square`.
    ///   - size: Minimum photo size. The current supported sizes are: `large`(24MP), `medium`(12MP) or `small`(4MP).
    ///   - color: Desired photo color. Supported colors: `red`, `orange`, `yellow`, `green`, `turquoise`, `blue`, `violet`, `pink`, `brown`, `black`, `gray`, `white` or any hexidecimal color code (eg. `#ffffff`).
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
        let parameters = [(query as APIParameterable?), orientation, size, color, locale, page, perPage]
        return APIRequest(method: .get, path: Path.search.rawValue, parameters: parameters)
    }
}
