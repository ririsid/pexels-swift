import HTTPTypes

extension HTTPField.Name {
    static let xRatelimitLimit = Self("X-Ratelimit-Limit")!
    static let xRatelimitRemaining = Self("X-Ratelimit-Remaining")!
    static let xRatelimitReset = Self("X-Ratelimit-Reset")!
}
