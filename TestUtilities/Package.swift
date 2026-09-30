// ATCHG: TowerSignal SDK migration - renamed `dd*` types to `TowerSignal*`; rebranded the `dd` name to
// `TowerSignal` in comments and docs.

// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "TestUtilities",
    platforms: [
        .iOS(.v12),
        .tvOS(.v12),
        .macOS(.v12),
        .watchOS(.v7),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "TestUtilities",
            targets: ["TestUtilities"]
        ),
    ],
    dependencies: [
        .package(name: "TowerSignal", path: ".."),
    ],
    targets: [
        .target(
            name: "TestUtilities",
            dependencies: [
                .product(name: "TowerSignalCore", package: "TowerSignal"),
                .product(name: "TowerSignalRUM", package: "TowerSignal"),
                .product(name: "TowerSignalLogs",package: "TowerSignal"),
                .product(name: "TowerSignalTrace",package: "TowerSignal"),
                .product(name: "TowerSignalCrashReporting",package: "TowerSignal"),
                .product(name: "TowerSignalSessionReplay", package: "TowerSignal"),
                .product(name: "TowerSignalWebViewTracking",package: "TowerSignal")
            ],
            path: ".",
            sources: ["Sources"],
            swiftSettings: [.define("SPM_BUILD")]
        ),
    ]
)
