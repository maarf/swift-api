// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "QminderAPI",
    products: [
        .library(
            name: "QminderAPI",
            targets: ["QminderAPI"])
    ],
    dependencies: [
        .package(url: "https://github.com/daltoniam/Starscream.git", from: "3.0.4")
    ],
    targets: [
        .target(
            name: "QminderAPI",
            dependencies: ["Starscream"],
            path: "Sources")
    ]
)
