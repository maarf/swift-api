// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TestWebsockets",
    dependencies: [
        .package(url: "https://github.com/vapor/websocket.git", from: "1.0.2"),
        .package(url: "https://github.com/vapor/http.git", from: "3.1.4"),
    ],
    targets: [
        .target(
            name: "TestWebsockets",
            dependencies: ["WebSocket", "HTTP"]),
    ]
)
