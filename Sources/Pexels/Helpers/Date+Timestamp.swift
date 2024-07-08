import Foundation

extension Date {
    /// Creates a date value initialized relative to 00:00:00 UTC on 1 January 1970 by a given number of seconds.
    public init?(timestamp: String) {
        guard let timeIntervalSince1970 = TimeInterval(timestamp) else { return nil }
        self.init(timeIntervalSince1970: timeIntervalSince1970)
    }
}
