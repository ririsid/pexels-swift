// This code was created by referencing Vapor's `Middleware` codes.
// * [MiddlewareConfiguration.swift](https://github.com/vapor/vapor/blob/main/Sources/Vapor/Middleware/MiddlewareConfiguration.swift)
// * [Middleware.swift](https://github.com/vapor/vapor/blob/main/Sources/Vapor/Middleware/Middleware.swift)

import Foundation

/// Manage multiple middleware.
public struct Middlewares: Sendable {
    /// Array of `Middleware`.
    private var middlewares: [Middleware] = []

    /// Add middleware.
    public mutating func use(_ middleware: Middleware...) {
        middleware.forEach { middlewares.append($0) }
    }

    /// Create a new responder that chains to the next responder.
    ///
    /// - Parameter responder: The next responder.
    /// - Returns: The new responder.
    public func respond(chainingTo responder: Responder) -> Responder {
        var responder = responder
        for middleware in middlewares.reversed() {
            responder = middleware.makeResponder(chainingTo: responder)
        }
        return responder
    }
}
