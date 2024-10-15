// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "GravlinkSDK",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Expose the binary framework as the product of the package
        .library(
            name: "GravlinkSDK",
            targets: ["GravlinkSDK"]
        ),
    ],
    dependencies: [
        // Add any other dependencies required by your package.
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.10.0"),
        .package(url: "https://github.com/stasel/WebRTC.git", from: "129.0.0"),
        .package(url: "https://github.com/socketio/socket.io-client-swift.git", branch: "master")
    ],
    targets: [
        // Binary target pointing to the XCFramework
        .binaryTarget(
            name: "GravlinkSDK",
            path: "./Sources/GlinkFramwork.xcframework"
        )
    ]
)
