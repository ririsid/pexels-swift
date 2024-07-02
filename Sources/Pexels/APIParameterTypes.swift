import Foundation

/// Parameter types in use by API services.
public enum APIParameterTypes {
    /// The search query. `Ocean`, `Tigers`, `Pears`, etc.
    public struct Query: RawRepresentable, APIParameterable {
        /// The raw type that can be used to represent all values of the conforming type.
        public typealias RawValue = String

        /// The corresponding value of the raw type.
        public let rawValue: RawValue

        /// Creates a new instance with the specified raw value.
        ///
        /// - Parameter rawValue: A raw value.
        public init?(rawValue: RawValue) {
            guard Self.isValid(rawValue) else { return nil }
            self.rawValue = rawValue
        }

        /// Returns `true` if the value is valid.
        ///
        /// - Parameter value: The value.
        /// - Returns: `true` if the value is valid; otherwise, `false`.
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
        case large // 24MP
        case medium // 12MP
        case small // 4MP
    }

    /// Desired photo color. Supported colors: `red`, `orange`, `yellow`, `green`, `turquoise`, `blue`, `violet`, `pink`, `brown`, `black`, `gray`, `white` or any hexadecimal color code (eg. `#ffffff`).
    public struct Color: RawRepresentable, APIParameterable {
        /// The raw type that can be used to represent all values of the conforming type.
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

        /// The corresponding value of the raw type.
        public let rawValue: RawValue

        /// Creates a new instance with the specified raw value.
        ///
        /// - Parameter rawValue: A raw value.
        public init?(rawValue: RawValue) {
            guard Self.isValid(rawValue) else { return nil }
            self.rawValue = rawValue
        }

        /// Creates a new instance with a `Named` color.
        ///
        /// - Parameter named: A `Named` color.
        private init(named: Named) {
            self.rawValue = named.rawValue
        }

        /// Creates a new instance with a hex color code.
        ///
        /// - Parameter hexColorCode: A hexadecimal color code.
        private init?(hexColorCode: String) {
            guard hexColorCode.isValidHexColorCode else { return nil }
            self.init(rawValue: hexColorCode)
        }

        /// Convert a hex color code to `Color`.
        ///
        /// - Parameter hexColorCode: A hexadecimal color code.
        public static func hexColorCode(_ hexColorCode: String) -> Color? {
            return Color(hexColorCode: hexColorCode)
        }

        /// Returns `true` if the value is valid.
        ///
        /// - Parameter value: The value.
        /// - Returns: `true` if the value is valid; otherwise, `false`.
        private static func isValid(_ value: RawValue) -> Bool {
            return Named.contains(value) || value.isValidHexColorCode
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
        /// The raw type that can be used to represent all values of the conforming type.
        public typealias RawValue = Int

        /// The default value.
        public static let `default`: RawValue = 1

        /// The corresponding value of the raw type.
        public let rawValue: RawValue

        /// Creates a new instance with the specified raw value.
        ///
        /// - Parameter rawValue: A raw value.
        public init?(rawValue: RawValue) {
            guard Self.isValid(rawValue) else { return nil }
            self.rawValue = rawValue
        }

        /// Returns `true` if the value is valid.
        ///
        /// - Parameter value: The value.
        /// - Returns: `true` if the value is valid; otherwise, `false`.
        private static func isValid(_ value: RawValue) -> Bool {
            return value >= Self.default
        }
    }

    /// The number of results you are requesting per page. `Default: 15` `Max: 80`
    public struct PerPage: RawRepresentable, APIParameterable {
        /// The raw type that can be used to represent all values of the conforming type.
        public typealias RawValue = Int

        /// The default value.
        public static let `default`: Int = 15

        /// The minimum value.
        public static let min: Int = 1

        /// The maximum value.
        public static let max: Int = 80

        /// The corresponding value of the raw type.
        public let rawValue: RawValue

        public let name: String = "per_page"

        /// Creates a new instance with the specified raw value.
        public init?(rawValue: RawValue) {
            guard Self.isValid(rawValue) else { return nil }
            self.rawValue = rawValue
        }

        /// Returns `true` if the value is valid.
        ///
        /// - Parameter value: The value.
        /// - Returns: `true` if the value is valid; otherwise, `false`.
        private static func isValid(_ value: RawValue) -> Bool {
            return Self.min...Self.max ~= value
        }
    }

    /// The minimum width in pixels of the returned videos.
    public struct MinWidth: RawRepresentable, APIParameterable {
        /// The raw type that can be used to represent all values of the conforming type.
        public typealias RawValue = Int

        /// The corresponding value of the raw type.
        public let rawValue: RawValue

        public let name: String = "min_width"

        /// Creates a new instance with the specified raw value.
        public init?(rawValue: RawValue) {
            guard Self.isValid(rawValue) else { return nil }
            self.rawValue = rawValue
        }

        /// Returns `true` if the value is valid.
        ///
        /// - Parameter value: The value.
        /// - Returns: `true` if the value is valid; otherwise, `false`.
        private static func isValid(_ value: RawValue) -> Bool {
            return value >= 0
        }
    }

    /// The minimum height in pixels of the returned videos.
    public struct MinHeight: RawRepresentable, APIParameterable {
        /// The raw type that can be used to represent all values of the conforming type.
        public typealias RawValue = Int

        /// The corresponding value of the raw type.
        public let rawValue: RawValue

        public let name: String = "min_height"

        /// Creates a new instance with the specified raw value.
        public init?(rawValue: RawValue) {
            guard Self.isValid(rawValue) else { return nil }
            self.rawValue = rawValue
        }

        /// Returns `true` if the value is valid.
        ///
        /// - Parameter value: The value.
        /// - Returns: `true` if the value is valid; otherwise, `false`.
        private static func isValid(_ value: RawValue) -> Bool {
            return value >= 0
        }
    }

    /// The minimum duration in seconds of the returned videos.
    public struct MinDuration: APIParameterable, RawRepresentable {
        /// The raw type that can be used to represent all values of the conforming type.
        public typealias RawValue = Int

        /// The corresponding value of the raw type.
        public let rawValue: RawValue

        public let name: String = "min_duration"

        /// Creates a new instance with the specified raw value.
        public init?(rawValue: RawValue) {
            guard Self.isValid(rawValue) else { return nil }
            self.rawValue = rawValue
        }

        /// Returns `true` if the value is valid.
        ///
        /// - Parameter value: The value.
        /// - Returns: `true` if the value is valid; otherwise, `false`.
        private static func isValid(_ value: RawValue) -> Bool {
            return value >= 0
        }
    }

    /// The maximum duration in seconds of the returned videos.
    public struct MaxDuration: APIParameterable, RawRepresentable {
        /// The raw type that can be used to represent all values of the conforming type.
        public typealias RawValue = Int

        /// The corresponding value of the raw type.
        public let rawValue: RawValue

        public let name: String = "max_duration"

        /// Creates a new instance with the specified raw value.
        public init?(rawValue: RawValue) {
            guard Self.isValid(rawValue) else { return nil }
            self.rawValue = rawValue
        }

        /// Returns `true` if the value is valid.
        ///
        /// - Parameter value: The value.
        /// - Returns: `true` if the value is valid; otherwise, `false`.
        private static func isValid(_ value: RawValue) -> Bool {
            return value >= 0
        }
    }

    /// The type of media you are requesting. If not given or if given with an invalid value, all media will be returned. Supported values are `photos` and `videos`.
    public enum MediaType: String, APIParameterable {
        case photos
        case videos

        public var name: String { "type" }
    }

    /// The order of items in the media collection. Supported values are: `asc`, `desc`. `Default: asc`
    public enum Sort: String, APIParameterable {
        case ascending = "asc"
        case descending = "desc"
    }
}

// MARK: - APIParameterable

/// Convertible types to API parameters.
public protocol APIParameterable {
    /// The parameter name.
    var name: String { get }

    /// The parameter value.
    var value: String? { get }
}

extension APIParameterable {
    // Nested types of `APIParameterTypes` use lowercased type names.
    public var name: String {
        String(describing: type(of: self)).lowercased()
    }
}

extension APIParameterable where Self: RawRepresentable<String> {
    public var value: String? {
        rawValue
    }

    /// Creates a new instance with a value.
    ///
    /// - Parameter value: A value.
    public init?(_ value: Self.RawValue) {
        guard Self.isValid(value) else { return nil }
        self.init(rawValue: value)
    }

    /// Returns `true` if the value is valid.
    ///
    /// - Parameter value: The value.
    /// - Returns: `true` if the value is valid; otherwise, `false`.
    internal static func isValid(_ value: Self.RawValue) -> Bool {
        return !value.isEmpty
    }
}

extension APIParameterable where Self: RawRepresentable<Int> {
    public var value: String? {
        String(rawValue)
    }

    /// Creates a new instance with a value.
    ///
    /// - Parameter value: A value.
    public init?(_ value: Self.RawValue) {
        self.init(rawValue: value)
    }

    /// Creates a new instance with a value.
    ///
    /// - Parameter value: A value.
    public init?(_ value: Self.RawValue?) {
        guard let value else { return nil }
        self.init(rawValue: value)
    }
}

extension URLQueryItem {
    /// Creates a new instance with a `APIParameterable` value.
    ///
    /// - Parameter apiParameter: A `APIParameterble` value.
    init(_ apiParameter: APIParameterable) {
        self.init(name: apiParameter.name, value: apiParameter.value)
    }
}
