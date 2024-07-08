// swift-tools-version: 5.9.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Pexels",
    defaultLocalization: "en",
    platforms: [
        // Support for Swift Concurrency
        .macOS(.v10_15), .iOS(.v13), .watchOS(.v6), .tvOS(.v13), .macCatalyst(.v13), .visionOS(.v1)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "Pexels", targets: ["Pexels"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-http-types.git", from: "1.2.0"),
        .package(url: "https://github.com/apple/swift-docc-plugin.git", from: "1.3.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Pexels",
            dependencies: [
                .product(name: "HTTPTypes", package: "swift-http-types"),
                .product(name: "HTTPTypesFoundation", package: "swift-http-types"),
            ],
            resources: [.process("Resources")]),
        .testTarget(
            name: "PexelsTests",
            dependencies: ["Pexels"],
            resources: [.process("Resources")]),
    ]
)
