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
    dependencies: [
        .package(
            url: "https://github.com/kerimovq5-blip/SilentMoonData.git",
            branch: "main"
                )
        
        
    ],
    targets: [
        .target(
            name: "SilentMoonNetwork",
            dependencies: [
                "SilentMoonData"
            ]
        ),
    ]
)
