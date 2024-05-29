// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "data",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "data",
            targets: ["data"]),
    ],
    dependencies: [
        .package(name: "model", path: "../model"),
        .package(name: "cache", path: "../cache"),
        .package(name: "remote", path: "../remote"),
        .package(name: "util", path: "../util"),
        .package(name: "preferences", path: "../preferences"),
        .package(name: "analytics", path: "../analytics"),
        .package(url: "https://github.com/hmlongco/Factory", branch: "main"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "data",
            dependencies: [
                "model",
                "cache",
                "remote",
                "analytics",
                "preferences",
                "Factory"
            ]),
        .testTarget(
            name: "dataTests",
            dependencies: [
                "data",
                "util"
            ]),
    ]
)

