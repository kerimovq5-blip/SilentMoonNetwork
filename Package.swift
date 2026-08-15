// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "SilentMoonNetwork",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "SilentMoonNetworkCommon",
                 targets: ["SilentMoonNetworkCommon"]),
        
        .library(name: "SilentMoonDTOs",
                 targets: ["SilentMoonDTOs"]),
        
        .library(name: "SilentMoonManagers",
                 targets: ["SilentMoonManagers"]) ,
 
    .library(
           name: "SilentMoonApiService",
           targets: ["SilentMoonApiService"]
       )
   ],
    targets: [
        .target(
            name: "SilentMoonNetworkCommon"
        ),
        .target(
            name: "SilentMoonDTOs",
            dependencies: [
                "SilentMoonNetworkCommon"
            ]
        ),
        .target(
            name: "SilentMoonManagers",
            dependencies: [
                "SilentMoonNetworkCommon",
                "SilentMoonDTOs",
                
            ]
        ),
        .target(
                name: "SilentMoonApiService",
                dependencies: [
                    "SilentMoonNetworkCommon",
                    "SilentMoonDTOs",
                    "SilentMoonManagers"
                ]
            )
        ]
    
)
