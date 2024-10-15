// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "GravlinkSDK",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "GravlinkSDK",
            targets: ["GravlinkBinary"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.10.0"),
        .package(url: "https://github.com/stasel/WebRTC.git", from: "129.0.0"),
        .package(url: "https://github.com/socketio/socket.io-client-swift.git", branch: "master")
    ],
    targets: [
        .binaryTarget(
            name: "GravlinkBinary",
            path: "./Sources/GlinkFramwork.xcframework"
        ),
        .target(
            name: "GravlinkExtras",
            dependencies: [
                "Alamofire",
                "WebRTC",
                .product(name: "SocketIO", package: "socket.io-client-swift"),
                "GravlinkBinary"
            ],
            path: "./Sources"
        )
    ]
)
