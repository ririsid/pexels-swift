import struct HTTPTypes.HTTPField

extension HTTPTypes.HTTPField.Name {
    /// Your total request limit for the monthly period.
    static let xRatelimitLimit = Self("X-Ratelimit-Limit")!

    /// How many of these requests remain.
    static let xRatelimitRemaining = Self("X-Ratelimit-Remaining")!

    /// UNIX timestamp of when the currently monthly period will roll over.
    static let xRatelimitReset = Self("X-Ratelimit-Reset")!
}
