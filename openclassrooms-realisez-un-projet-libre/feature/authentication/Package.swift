// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "authentication",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "authentication",
            targets: ["authentication"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(name: "common", path: "../../core/common"),
        .package(name: "domain", path: "../../core/domain"),
        .package(name: "designsystem", path: "../../core/designsystem"),
        .package(name: "testing", path: "../testing"),
        .package(name: "util", path: "../util"),
        .package(name: "ui", path: "../../core/ui"),
        .package(name: "navigation", path: "../../core/navigation")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "authentication",
            dependencies: [
                "domain",
                "designsystem",
                "common",
                "ui",
                "navigation"
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "authenticationTests",
            dependencies: [
                "authentication",
                "testing",
                "util"
            ])
    ]
)
