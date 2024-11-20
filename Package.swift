// swift-tools-version:5.10

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
            ],
            path: "Tests"
        ),
    ]
)
