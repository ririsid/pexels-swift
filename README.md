# Pexels Swift Library

The Pexels Swift library is a convenient wrapper around the Pexels API that lets you access the full Pexels content library, including photos and videos, using Swift.

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
    ),
```

## Documentation

See the API docs [here](https://www.pexels.com/api/documentation/)
