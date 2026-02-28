// swift-tools-version:5.10

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
        .library(name: "DayTypeMacros", targets: ["DayTypeMacros"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.0"),
    ],
    targets: [
        .target(
            name: "DayType",
            dependencies: [
                "DayTypeMacros",
            ],
            path: "Sources"
        ),
        .target(
            name: "DayTypeMacros",
            dependencies: [
                "DayTypeMacroImplementations",
            ],
            path: "Macros/Module"
        ),
        .macro(
            name: "DayTypeMacroImplementations",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftDiagnostics", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ],
            path: "Macros/Implementations"
        ),
        .testTarget(
            name: "DayTypeTests",
            dependencies: [
                "DayType",
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
            ],
            path: "Tests"
        ),
    ]
)
