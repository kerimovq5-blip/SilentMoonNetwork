// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "SilentMoonNetwork",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "SilentMoonNetworkCommon",
                 targets: ["SilentMoonNetworkCommon"]),
    ],
    targets: [
        .target(
            name: "SilentMoonNetworkCommon"
        ),
    ]
)
