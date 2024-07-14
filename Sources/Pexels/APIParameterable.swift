import Foundation

/// Convertible types to API parameters.
public protocol APIParameterable: Sendable {
    /// The parameter name.
    static var name: String { get }

    /// The parameter value.
    var value: String? { get }
}

extension APIParameterable {
    // Nested types of `APIParameterTypes` use lowercased type names.
    public var name: String {
        type(of: self).name
    }
}

extension APIParameterable where Self: RawRepresentable {
    /// Creates a new instance with a value.
    ///
    /// - Parameter value: A value.
    public init?(_ value: Self.RawValue?) {
        guard let value else { return nil }
        self.init(rawValue: value)
    }
}

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

extension URLQueryItem {
    /// Creates a new instance with a `APIParameterable` value.
    ///
    /// - Parameter apiParameter: A `APIParameterble` value.
    init(_ apiParameter: APIParameterable) {
        self.init(name: apiParameter.name, value: apiParameter.value)
    }
}
