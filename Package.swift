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
        .package(url: "https://github.com/daltoniam/Starscream.git", from: "3.0.5")
    ],
    targets: [
        .target(
            name: "QminderAPI",
            dependencies: ["Starscream"],
            path: "Sources")
    ]
)
