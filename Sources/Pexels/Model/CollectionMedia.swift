import Foundation

/// The `Media` object.
public struct CollectionMedia: Decodable, Equatable, Identifiable, Pageable {
    /// The id of the collection you are requesting.
    public let id: String

    /// An array of media objects. Each object has an extra `type` attribute to indicate the type of object.
    ///
    /// array of `Photo` or `Video` objects.
    public let media: [Self.Media]

    public let page: Int
    public let perPage: Int
    public let totalResults: Int

    public let previousPageURL: URL?
    public let nextPageURL: URL?

    /// Creates a new instance by decoding from the given decoder.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.media = try container.decode([Self.Media].self, forKey: .media)
        self.page = try container.decode(Int.self, forKey: .page)
        self.perPage = try container.decode(Int.self, forKey: .perPage)
        self.totalResults = try container.decode(Int.self, forKey: .totalResults)
        self.previousPageURL = try container.decodeIfPresent(URL.self, forKey: .previousPageURL)
        self.nextPageURL = try container.decodeIfPresent(URL.self, forKey: .nextPageURL)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case media
        case page
        case perPage = "per_page"
        case totalResults = "total_results"
        case previousPageURL = "prev_page"
        case nextPageURL = "next_page"
    }

    // MARK: - Nested Types

    /// Indicate the type of media and contain a `Photo` or `Video`.
    public struct Media: Decodable, Equatable {
        /// The id of the collection you are requesting.
        public let type: MediaType
        public let media: AnyMedia

        /// Creates a new instance by decoding from the given decoder.
        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.type = try container.decode(MediaType.self, forKey: .type)
            switch self.type {
            case .photo:
                self.media = .photo(try Photo(from: decoder))
            case .video:
                self.media = .video(try Video(from: decoder))
            }
        }

        enum CodingKeys: String, CodingKey {
            case type
        }
    }

    /// Indicate the type of media.
    public enum MediaType: String, Decodable {
        case photo = "Photo"
        case video = "Video"
    }

    /// A media object containing a `Photo` or `Video`.
    public enum AnyMedia: Equatable {
        case photo(Photo)
        case video(Video)
    }
}
