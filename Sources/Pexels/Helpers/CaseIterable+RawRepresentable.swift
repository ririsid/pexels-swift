import Foundation

extension CaseIterable where Self: RawRepresentable, RawValue: Equatable {
    /// Returns a Boolean value indicating whether the all cases contain a raw value.
    ///
    /// - Parameter rawValue: A raw value.
    /// - Returns: `true` if the all cases contain a raw value; otherwise, `false`.
    static func contains(_ rawValue: RawValue) -> Bool {
        return Self.allCases.contains { $0.rawValue == rawValue }
    }
}
