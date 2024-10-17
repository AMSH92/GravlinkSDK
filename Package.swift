// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "GravlinkSDK",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "GravlinkSDK",
            targets: ["GlinkFramework"] // Only include the binary framework here
        ),
    ],
    dependencies: [
        // Add external dependencies here if needed by the framework
        .package(url: "https://github.com/Alamofire/Alamofire", from: "5.4.0"),
        .package(url: "https://github.com/stasel/WebRTC.git", from: "94.0.0"),
        .package(url: "https://github.com/socketio/socket.io-client-swift", branch: "master"),
    ],
    targets: [
        .binaryTarget(
            name: "GlinkFramework",  // Matches the framework and binary name
            path: "./build/GlinkFramework.xcframework"  // Path to the .xcframework
        )
    ]
)
