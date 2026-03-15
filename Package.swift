// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "HealthHub",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "HealthHub",
            targets: ["HealthHub"]
        ),
    ],
    targets: [
        .target(
            name: "HealthHub",
            path: "HealthHub"
        ),
        .testTarget(
            name: "HealthHubTests",
            dependencies: ["HealthHub"],
            path: "Tests"
        ),
    ]
)
