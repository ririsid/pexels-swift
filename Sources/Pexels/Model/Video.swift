import Foundation

/// The `Video` object.
public struct Video: Decodable, Identifiable, Equatable {
    /// The id of the video.
    public let id: Int

    /// The real width of the video in pixels.
    public let width: Int

    /// The real height of the video in pixels.
    public let height: Int

    /// The Pexels URL where the video is located.
    public let url: URL

    /// URL to a screenshot of the video.
    public let image: URL

    /// The duration of the video in seconds.
    public let duration: Int

    /// The videographer who shot the video.
    public let videographer: Videographer

    /// An array of different sized versions of the video.
    public let videoFiles: [VideoFile]

    /// An array of preview pictures of the video.
    public let videoPictures: [VideoPicture]

    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case url
        case image
        case duration
        case videographer = "user"
        case videoFiles = "video_files"
        case videoPictures = "video_pictures"
    }

    // MARK: - Nested Types

    /// The `Videographer` object.
    public struct Videographer: Decodable, Identifiable, Equatable {
        /// The id of the videographer.
        public let id: Int

        /// The name of the videographer.
        public let name: String

        /// The URL of the videographer's Pexels profile.
        public let url: URL
    }

    /// The `VideoFile` object.
    public struct VideoFile: Decodable, Identifiable, Equatable {
        /// The id of the `video_file`.
        public let id: Int

        /// The video quality of the `video_file`.
        public let quality: String

        /// The video format of the `video_file`.
        public let format: String

        /// The width of the `video_file` in pixels.
        public let width: Int

        /// The height of the `video_file` in pixels.
        public let height: Int

        /// The number of frames per second of the `video_file`.
        public let fps: Double

        /// A link to where the `video_file` is hosted.
        public let link: URL

        /// The size of the `video_file`.
        public let size: Int

        enum CodingKeys: String, CodingKey {
            case id
            case quality
            case format = "file_type"
            case width
            case height
            case fps
            case link
            case size
        }
    }

    /// The `VideoPicture` object.
    public struct VideoPicture: Decodable, Identifiable, Equatable {
        /// The id of the `video_picture`.
        public let id: Int

        /// A link to the preview image.
        public let picture: URL

        public let nr: Int
    }
}
