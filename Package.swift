// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "AdSwapSDK",
    platforms: [
        .iOS(.v14) // Supporta da iOS 14 in su (99% dei dispositivi)
    ],
    products: [
        .library(
            name: "AdSwapSDK",
            targets: ["AdSwapSDK"]),
    ],
    targets: [
        .target(
            name: "AdSwapSDK",
            dependencies: [])
    ]
)
