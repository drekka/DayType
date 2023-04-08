// swift-tools-version:5.8

import PackageDescription

let package = Package(
    name: "DayType",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
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
            dependencies: [],
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
