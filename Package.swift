// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "QminderAPI",
    products: [
        .library(
            name: "QminderAPI",
            targets: ["QminderAPI"])
    ],
    dependencies: [
        .package(url: "https://github.com/daltoniam/Starscream.git", from: "3.0.6"),
        .package(url: "https://github.com/apollographql/apollo-ios.git", from: "0.9.4")
    ],
    targets: [
        .target(
            name: "QminderAPI",
            dependencies: ["Starscream", "Apollo"],
            path: "Sources")
    ]
)
