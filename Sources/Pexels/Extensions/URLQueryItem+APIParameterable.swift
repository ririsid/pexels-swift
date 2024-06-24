import Foundation

extension URLQueryItem {
    init(_ apiParameter: APIParameterable) {
        self.init(name: apiParameter.name, value: apiParameter.value)
    }
}
