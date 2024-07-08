# Pexels Swift Library

The Pexels Swift library is a convenient wrapper around the Pexels API that lets you access the full Pexels content library, including photos and videos, using Swift.

## Table of Contents
1. [Installation](#installation)
2. [Documentation](#documentation)
3. [Usage](#usage)
4. [Tests](#tests)

## Installation

In your `Package.swift` Swift Package Manager manifest, add the following dependency to your `dependencies` argument:

```swift
.package(url: "https://github.com/ririsid/pexels-swift.git", branch: "main"),
```

Add the dependency to any targets you've declared in your manifest:

```swift
.target(
    name: "MyTarget",
    dependencies: [
        .product(name: "Pexels", package: "pexels-swift"),
    ]
)
```

## Documentation

See the API docs [here](https://www.pexels.com/api/documentation/)

## Usage

### Basic usage

```swift
import Pexels

let apiKey = "<YOUR PEXELS API KEY>"
let configuration = APIConfiguration(with: apiKey)
var provider = APIProvider(configuration: configuration)
var request = try APIEndpoint.Photos.search(query: "nature")
let response = try await provider.request(&request)
response.photos.forEach {
    print($0.url)
}
```

### Create an API Provider

```swift
import Pexels

let apiKey = "<YOUR PEXELS API KEY>"
let configuration = APIConfiguration(with: apiKey)
var provider = APIProvider(configuration: configuration)
```

### Photos

#### Search for Photos

```swift
var request = try APIEndpoint.Photos.search(query: "nature", orientation: .landscape, size: .large, color: .red, locale: .koKR, page: 1, perPage: 15)
let response = try await provider.request(&request)
```

#### Curated Photos

```swift
var request = try APIEndpoint.Photos.curated(page: 1, perPage: 15)
let response = try await provider.request(&request)
```

#### Get a Photo

```swift
var request = try APIEndpoint.Photos.photo(id: 2014422)
let response = try await provider.request(&request)
```

### Videos

#### Search for Videos

```swift
var request = try APIEndpoint.Videos.search(query: "nature", orientation: .landscape, size: .large, locale: .koKR, page: 1, perPage: 15)
let response = try await provider.request(&request)
```

#### Popular Videos

```swift
var request = try APIEndpoint.Videos.popular(minWidth: 1024, minHeight: 1024, minDuration: 1, maxDuration: 60, page: 1, perPage: 15)
let response = try await provider.request(&request)
```

#### Get a Video

```swift
var request = try APIEndpoint.Videos.video(id: 2499611)
let response = try await provider.request(&request)
```

### Collections

#### Featured Collections

```swift
var request = try APIEndpoint.Collections.featured(page: 1, perPage: 15)
let response = try await provider.request(&request)
```

#### My Collections

```swift
var request = try APIEndpoint.Collections.my(page: 1, perPage: 15)
let response = try await provider.request(&request)
```

#### Collection Media

```swift
var request = try APIEndpoint.Collections.media(id: "9j7p6tj", type: .photos, sort: .ascending, page: 1, perPage: 15)
let response = try await provider.request(&request)
```

### Request Statistics

```swift
var request = try APIEndpoint.Photos.search(query: "nature")
let response = try await provider.request(&request)
if let quota = provider.quota {
    print("Request limit: \(quota.requestLimit)")
    print("Request remaining: \(quota.requestRemaining)")
    print("Reset date: \(quota.resetTime)")
}
```

### Pagination

```swift
// First page
var request = try APIEndpoint.Photos.search(query: "nature")
let response = try await provider.request(&request)

// Next page
if let nextPageURL = response.nextPageURL {
    var nextPageRequest = request.makeRequest(with: nextPageURL)
    let nextPageResponse = try await provider.request(&nextPageRequest)
    print("Page: \(nextPageResponse.page)") // Page: 2
}
```

### Middleware

Middleware works between receiving and responding to requests.

```swift
struct LoggingMiddleware: Middleware {
    func respond(to request: HTTPTypes.HTTPRequest, chainingTo next: Responder) async throws -> (Data, HTTPTypes.HTTPResponse) {
        print("Start a request: \(request.url!)")
        let (data, response) = try await next.respond(to: request)
        print("Received a response: \(response.status)")
        return (data, response)
    }
}
```

You can add multiple middleware to the API provider.

```swift
provider.middleware.use(LoggingMiddleware(), OtherMiddleware())
var request = try APIEndpoint.Photos.search(query: "nature")
let response = try await provider.request(&request)
```

## Tests

To run the tests you need to provide your own api key. You can get one from here: https://www.pexels.com/api/new/

#### In the terminal

```
PEXELS_API_KEY=<YOUR PEXELS API KEY> swift test
```
