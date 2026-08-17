// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SilentMoonNetwork",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "SilentMoonNetwork",
            targets: ["SilentMoonNetwork"]
        ),
    ],
    targets: [
        .target(
            name: "SilentMoonNetwork"
        ),
    ]
)
