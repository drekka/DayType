// swift-tools-version:5.9

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "DayType",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
    ],
    products: [
        .library(name: "DayType", targets: ["DayType"]),
    ],
    dependencies: [
        .package(url: "https://github.com/quick/nimble", from: "11.0.0"),
    ],
    targets: [
        .target(
            name: "DayType",
            path: "Sources"
        ),
        .testTarget(
            name: "DayTypeTests",
            dependencies: [
                "DayType",
                .product(name: "Nimble", package: "nimble"),
            ],
            path: "Tests"
        ),
    ]
)
