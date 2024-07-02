import Foundation

/// The `Photo` object.
public struct Photo: Decodable, Identifiable, Equatable {
    /// The id of the photo.
    public let id: Int

    /// The real width of the photo in pixels.
    public let width: Int

    /// The real height of the photo in pixels.
    public let height: Int

    /// The Pexels URL where the photo is located.
    public let url: URL

    /// The photographer who took the photo.
    public let photographer: Self.Photographer

    /// The average color of the photo. Useful for a placeholder while the image loads.
    ///
    /// The value is a hex code. `#000000` to `#FFFFFF`
    public let averageColor: String

    /// An assortment of different image sizes that can be used to display this `Photo`.
    public let source: Self.Source

    /// Indicates whether you liked.
    public let liked: Bool

    /// Text description of the photo for use in the `alt` attribute.
    public let alternativeText: String

    /// Creates a new instance by decoding from the given decoder.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.width = try container.decode(Int.self, forKey: .width)
        self.height = try container.decode(Int.self, forKey: .height)
        self.url = try container.decode(URL.self, forKey: .url)
        self.photographer = try Photographer(from: decoder)
        self.averageColor = try container.decode(String.self, forKey: .averageColor)
        self.source = try container.decode(Self.Source.self, forKey: .source)
        self.liked = try container.decode(Bool.self, forKey: .liked)
        self.alternativeText = try container.decode(String.self, forKey: .alternativeText)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case url
        case photographer
        case averageColor = "avg_color"
        case source = "src"
        case liked
        case alternativeText = "alt"
    }

    // MARK: - Nested Types

    /// The `Photographer` object.
    public struct Photographer: Decodable, Identifiable, Equatable {
        /// The id of the photographer.
        public let id: Int

        /// The name of the photographer who took the photo.
        public let name: String

        /// The URL of the photographer's Pexels profile.
        public let url: URL

        enum CodingKeys: String, CodingKey {
            case id = "photographer_id"
            case name = "photographer"
            case url = "photographer_url"
        }
    }

    /// The `Source` object.
    public struct Source: Decodable, Equatable {
        /// The image without any size changes. It will be the same as the `width` and `height` attributes.
        public let original: URL

        /// The image resized to `W 940px X H 650px DPR 1`.
        public let large: URL

        /// The image resized `W 940px X H 650px DPR 2`.
        public let large2x: URL

        /// The image scaled proportionally so that it's new height is `350px`.
        public let medium: URL

        /// The image scaled proportionally so that it's new height is `130px`.
        public let small: URL

        /// The image cropped to `W 800px X H 1200px`.
        public let portrait: URL

        /// The image cropped to `W 1200px X H 627px`.
        public let landscape: URL

        /// The image cropped to `W 280px X H 200px`.
        public let tiny: URL
    }
}
