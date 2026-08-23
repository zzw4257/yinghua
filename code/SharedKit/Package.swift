// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "YinghuaCore",
    platforms: [
        .macOS(.v26),
        .iOS(.v18),
    ],
    products: [
        .library(name: "YinghuaCore", targets: ["YinghuaCore"]),
    ],
    targets: [
        .target(
            name: "YinghuaCore",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]
        ),
        .testTarget(
            name: "YinghuaCoreTests",
            dependencies: ["YinghuaCore"]
        ),
    ]
)
