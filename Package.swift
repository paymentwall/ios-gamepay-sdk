// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "GamePaySDK",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "GamePaySDK",
            targets: ["GamePaySDK"]),
        .library(
            name: "CardinalMobile",
            targets: ["CardinalMobile"]),
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "GamePaySDK",
            path: "GamePaySDK/GamePaySDK.xcframework"
        ),
        .binaryTarget(
            name: "CardinalMobile",
            path: "Frameworks/CardinalMobile.xcframework"
        ),
    ]
)
