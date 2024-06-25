import Foundation

extension String {
    /// Returns a Boolean value indicating whether a string is valid hex color code.
    ///
    /// - Starts with a hash symbol (#)
    /// - Contains only hexadecimal characters (letters A-F, a-f and digits 0-9)
    /// - Has a length of either 6 or 3 characters (excluding the hash)
    var isValidHexColorCode: Bool {
        let pattern = "^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$"
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = regex.firstMatch(in: self, range: NSRange(location: 0, length: self.count))
        return range != nil
    }
}
