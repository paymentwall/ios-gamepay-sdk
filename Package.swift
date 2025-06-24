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
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "GamePaySDK",
            path: "GamePaySDK/GamePaySDK.zip"
        )
    ]
)
