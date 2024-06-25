import Foundation

extension CaseIterable where Self: RawRepresentable, RawValue: Equatable {
    static func contains(_ value: RawValue) -> Bool {
        return Self.allCases.contains { $0.rawValue == value }
    }
}
