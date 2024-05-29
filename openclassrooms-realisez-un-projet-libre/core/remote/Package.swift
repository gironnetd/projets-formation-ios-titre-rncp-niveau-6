// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "remote",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15), .macOS(.v10_15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "remote",
            targets: ["remote"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(name: "model", path: "../model"),
        .package(name: "common", path: "../common"),
        .package(name: "navigation", path: "../navigation"),
        .package(url: "https://github.com/hmlongco/Factory", branch: "main"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", branch: "main"),
        .package(url: "https://github.com/google/GoogleSignIn-iOS", .upToNextMajor(from: "7.0.0")),
        .package(url: "https://github.com/facebook/facebook-ios-sdk", .upToNextMajor(from: "14.1.0")),
        .package(name: "util", path: "../util")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "remote",
            dependencies: [
                "model",
                "common",
                "navigation",
                "Factory",
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestoreSwift", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestoreCombine-Community", package: "firebase-ios-sdk"),
                .product(name: "FirebaseAuthCombine-Community", package: "firebase-ios-sdk"),
                .product(name: "FacebookLogin", package: "facebook-ios-sdk"),
                .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS"),
//                .product(name: "FirebasePerformance", package: "firebase-ios-sdk")
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "remoteTests",
            dependencies: [
                "remote",
                "util",
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestoreSwift", package: "firebase-ios-sdk")
            ],
            resources: [
                .process("GoogleService-Info.plist")
            ]
        ),
    ]
)
