// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TestWebsockets",
    dependencies: [
        .package(url: "https://github.com/vapor/websocket.git", from: "1.0.0"),
        .package(url: "https://github.com/vapor/http.git", from: "3.0.0"),
    ],
    targets: [
        .target(
            name: "TestWebsockets",
            dependencies: ["WebSocket", "HTTP"]),
    ]
)


