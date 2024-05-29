// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "work",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "work",
            targets: ["work"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        //.package(url: "https://github.com/vrtdev/ios-workmanager", branch: "master"),
        .package(name: "common", path: "../../core/common"),
        .package(name: "analytics", path: "../../core/analytics"),
        .package(name: "data", path: "../../core/data")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "work",
            dependencies: [
                "common",
                "analytics",
                "data"
            ]),
        .testTarget(
            name: "workTests",
            dependencies: ["work"]),
    ]
)
