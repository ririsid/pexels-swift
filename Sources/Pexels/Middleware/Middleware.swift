// This code was created by referencing Vapor's `Middleware` codes.
// * [Responder.swift](https://github.com/vapor/vapor/blob/main/Sources/Vapor/HTTP/Responder.swift)
// * [Middleware.swift](https://github.com/vapor/vapor/blob/main/Sources/Vapor/Middleware/Middleware.swift)

import Foundation
import HTTPTypes

/// The responder.
public protocol Responder: Sendable {
    /// Receives an HTTP request and returns a response.
    ///
    /// - Parameter request: The incoming request.
    /// - Returns: The responses.
    func respond(to request: HTTPTypes.HTTPRequest) async throws -> (Data, HTTPTypes.HTTPResponse)
}

/// Middleware works between HTTP requests and responses.
public protocol Middleware: Sendable {
    /// Receive an HTTP request and execute the next responder.
    ///
    /// - Parameters:
    ///   - request: The incoming request.
    ///   - next: The next responder.
    /// - Returns: The responses.
    func respond(to request: HTTPTypes.HTTPRequest, chainingTo next: Responder) async throws -> (Data, HTTPTypes.HTTPResponse)
}

public extension Middleware {
    /// Create a new responder that chains to the next responder.
    ///
    /// - Parameter responder: The next responder.
    /// - Returns: The new responder.
    func makeResponder(chainingTo responder: Responder) -> Responder {
        return HTTPMiddlewareResponder(middleware: self, responder: responder)
    }
}

/// Chaining a request to a responder.
private struct HTTPMiddlewareResponder: Responder {
    private let middleware: Middleware
    private let responder: Responder

    init(middleware: Middleware, responder: Responder) {
        self.middleware = middleware
        self.responder = responder
    }

    /// Chains an incoming request to another responder.
    ///
    /// - Parameter request: The incoming request.
    /// - Returns: The responses.
    func respond(to request: HTTPTypes.HTTPRequest) async throws -> (Data, HTTPTypes.HTTPResponse) {
        return try await middleware.respond(to: request, chainingTo: self.responder)
    }
}
