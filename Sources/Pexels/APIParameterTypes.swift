import Foundation

// MARK: - APIParameterable

public protocol APIParameterable {
    var name: String { get }
    var value: String? { get }
}

extension APIParameterable {
    public var name: String {
        String(describing: type(of: self)).lowercased()
    }
}

extension APIParameterable where Self: RawRepresentable<String> {
    public var value: String? {
        rawValue
    }
}

extension APIParameterable where Self: RawRepresentable<Int> {
    public var value: String? {
        String(rawValue)
    }
}

// MARK: - APIParameterTypes

public enum APIParameterTypes {
    public struct Query: RawRepresentable, APIParameterable {
        public typealias RawValue = String

        public let rawValue: RawValue

        public init?(_ query: String) {
            guard Self.isValid(query) else { return nil }
            self.rawValue = query
        }

        public init?(rawValue: RawValue) {
            self.init(rawValue)
        }

        private static func isValid(_ value: RawValue) -> Bool {
            return !value.isEmpty
        }
    }

    /// Desired photo orientation. The current supported orientations are: `landscape`, `portrait` or `square`.
    public enum Orientation: String, APIParameterable {
        case landscape
        case portrait
        case square
    }

    /// Minimum photo size. The current supported sizes are: `large`(24MP), `medium`(12MP) or `small`(4MP).
    public enum Size: String, APIParameterable {
        case large /// 24MP
        case medium /// 12MP
        case small /// 4MP
    }

    /// Desired photo color. Supported colors: `red`, `orange`, `yellow`, `green`, `turquoise`, `blue`, `violet`, `pink`, `brown`, `black`, `gray`, `white` or any hexidecimal color code (eg. `#ffffff`).
    public struct Color: RawRepresentable, APIParameterable {
        public typealias RawValue = String

        /// Colors with names. Supported colors: `red`, `orange`, `yellow`, `green`, `turquoise`, `blue`, `violet`, `pink`, `brown`, `black`, `gray`, `white`.
        private enum Named: String, CaseIterable {
            case red
            case orange
            case yellow
            case green
            case turquoise
            case blue
            case violet
            case pink
            case brown
            case black
            case gray
            case white
        }

        public static let red = Color(named: .red)
        public static let orange = Color(named: .orange)
        public static let yellow = Color(named: .yellow)
        public static let green = Color(named: .green)
        public static let turquoise = Color(named: .turquoise)
        public static let blue = Color(named: .blue)
        public static let violet = Color(named: .violet)
        public static let pink = Color(named: .pink)
        public static let brown = Color(named: .brown)
        public static let black = Color(named: .black)
        public static let gray = Color(named: .gray)
        public static let white = Color(named: .white)

        public static func hexColorCode(_ hexColorCode: String) -> Color? {
            return Color(hexColorCode: hexColorCode)
        }

        public let rawValue: RawValue

        private init(value: String) {
            self.rawValue = value
        }

        public init?(rawValue: RawValue) {
            guard Self.isValid(rawValue) else { return nil }
            self.init(value: rawValue)
        }

        private init?(hexColorCode: String) {
            guard hexColorCode.isValidHexColorCode else { return nil }
            self.init(value: hexColorCode)
        }

        private init(named: Named) {
            self.init(value: named.rawValue)
        }

        private static func isValid(_ value: RawValue) -> Bool {
            return Named.contains(value)
            || value.isValidHexColorCode
        }
    }

    /// The locale of the search you are performing. The current supported locales are: `'en-US'` `'pt-BR'` `'es-ES'` `'ca-ES'` `'de-DE'` `'it-IT'` `'fr-FR'` `'sv-SE'` `'id-ID'` `'pl-PL'` `'ja-JP'` `'zh-TW'` `'zh-CN'` `'ko-KR'` `'th-TH'` `'nl-NL'` `'hu-HU'` `'vi-VN'` `'cs-CZ'` `'da-DK'` `'fi-FI'` `'uk-UA'` `'el-GR'` `'ro-RO'` `'nb-NO'` `'sk-SK'` `'tr-TR'` `'ru-RU'`.
    public enum Locale: String, APIParameterable {
        case enUS = "en-US"
        case ptBR = "pt-BR"
        case esES = "es-ES"
        case caES = "ca-ES"
        case deDE = "de-DE"
        case itIT = "it-IT"
        case frFR = "fr-FR"
        case svSE = "sv-SE"
        case idID = "id-ID"
        case plPL = "pl-PL"
        case jaJP = "ja-JP"
        case zhTW = "zh-TW"
        case zhCN = "zh-CN"
        case koKR = "ko-KR"
        case thTH = "th-TH"
        case nlNL = "nl-NL"
        case huHU = "hu-HU"
        case viVN = "vi-VN"
        case csCZ = "cs-CZ"
        case daDK = "da-DK"
        case fiFI = "fi-FI"
        case ukUA = "uk-UA"
        case elGR = "el-GR"
        case roRO = "ro-RO"
        case nbNO = "nb-NO"
        case skSK = "sk-SK"
        case trTR = "tr-TR"
        case ruRU = "ru-RU"
    }

    /// The page number you are requesting. `Default: 1`
    public struct Page: RawRepresentable, APIParameterable {
        public typealias RawValue = Int

        public static let `default`: RawValue = 1

        public let rawValue: RawValue

        public init?(_ page: Int) {
            guard Self.isValid(page) else { return nil }
            self.rawValue = page
        }

        public init?(rawValue: RawValue) {
            self.init(rawValue)
        }

        private static func isValid(_ value: RawValue) -> Bool {
            return value >= Self.default
        }
    }

    /// The number of results you are requesting per page. `Default: 15` `Max: 80`
    public struct PerPage: RawRepresentable, APIParameterable {
        public typealias RawValue = Int

        public static let `default`: Int = 15
        public static let min: Int = 1
        public static let max: Int = 80

        public let rawValue: RawValue
        public let name: String = "per_page"

        public init?(_ perPage: Int) {
            guard Self.isValid(perPage) else { return nil }
            self.rawValue = perPage
        }

        public init?(rawValue: RawValue) {
            self.init(rawValue)
        }

        private static func isValid(_ value: RawValue) -> Bool {
            return Self.min...Self.max ~= value
        }
    }
}
