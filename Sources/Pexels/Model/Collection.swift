import Foundation

/// The `Collection` object.
public struct MediaCollection: Decodable, Identifiable, Equatable {
    /// The id of the collection.
    public let id: String

    /// The name of the collection.
    public let title: String

    /// The description of the collection.
    public let description: String

    /// Whether or not the collection is marked as private.
    public let isPrivate: Bool

    /// The total number of media included in this collection.
    public let mediaCount: Int

    /// The total number of photos included in this collection.
    public let photosCount: Int

    /// The total number of videos included in this collection.
    public let videosCount: Int

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case isPrivate = "private"
        case mediaCount = "media_count"
        case photosCount = "photos_count"
        case videosCount = "videos_count"
    }
}
