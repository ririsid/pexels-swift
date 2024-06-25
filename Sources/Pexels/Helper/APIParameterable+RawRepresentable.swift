import Foundation

extension APIParameterable where Self: RawRepresentable<String> {
    public var value: String? {
        rawValue
    }
}

extension APIParameterable where Self: RawRepresentable<Int> {
    public var value: String? {
        String(rawValue)
    }
}
