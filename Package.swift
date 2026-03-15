// swift-tools-version:5.10

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "DayType",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        .library(name: "DayType", targets: ["DayType"]),
        .library(name: "DayTypeMacros", targets: ["DayTypeMacros"]),
        .library(name: "DayTypeUI", targets: ["DayTypeUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "602.0.0"),
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.1.0"),
    ],
    targets: [
        .target(
            name: "DayType",
            dependencies: [
                "DayTypeMacros",
                .product(name: "OrderedCollections", package: "swift-collections"),
            ],
            path: "Sources/api"
        ),
        .target(
            name: "DayTypeUI",
            dependencies: [
                "DayType",
            ],
            path: "Sources/ui"
        ),
        .target(
            name: "DayTypeMacros",
            dependencies: [
                "DayTypeMacroImplementations",
            ],
            path: "Sources/macros/Module"
        ),
        .macro(
            name: "DayTypeMacroImplementations",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftDiagnostics", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ],
            path: "Sources/macros/Implementations"
        ),
        .testTarget(
            name: "DayTypeTests",
            dependencies: [
                "DayType",
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
            ],
            path: "Tests/api"
        ),
        .testTarget(
            name: "DayTypeUITests",
            dependencies: [
                "DayTypeUI",
            ],
            path: "Tests/ui"
        ),
    ]
)
