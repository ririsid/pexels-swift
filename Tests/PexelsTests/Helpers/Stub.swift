import Foundation
@testable import Pexels
import HTTPTypes

struct StubResponseAPIRequestSession: APIRequestSession {
    let data: Data
    let status: HTTPTypes.HTTPResponse.Status
    let headerFields: HTTPTypes.HTTPFields

    init(data: Data, status: HTTPTypes.HTTPResponse.Status = .ok, headerFields: HTTPTypes.HTTPFields = HTTPTypes.HTTPFields()) {
        self.data = data
        self.status = status
        self.headerFields = headerFields
    }

    func data(for request: HTTPTypes.HTTPRequest) async throws -> (Data, HTTPTypes.HTTPResponse) {
        return (data, HTTPTypes.HTTPResponse(status: status, headerFields: headerFields))
    }
}

struct StubAPIConfiguration: APIConfigurable {
    let apiKey: String
    let scheme: String?
    let authority: String?
}
