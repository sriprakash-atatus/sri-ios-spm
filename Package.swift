// swift-tools-version: 6.0

// ATCHG: TowerSignal SDK migration - renamed `dd*` types to `TowerSignal*`; renamed the `DD` symbol prefix to
// `AT`; rebranded the `dd` name to `TowerSignal` in comments and docs.

import PackageDescription
import Foundation

let internalSwiftSettings: [SwiftSetting] = ProcessInfo.processInfo.environment["AT_BENCHMARK"] != nil ?
    [.define("AT_BENCHMARK")] : []

let package = Package(
    name: "TowerSignal",
    platforms: [
        .iOS(.v12),
        .tvOS(.v12),
        .macOS("12.6"),
        .watchOS(.v7),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "TowerSignalCore",
            targets: ["TowerSignalCore"]
        ),
        .library(
            name: "TowerSignalLogs",
            targets: ["TowerSignalLogs"]
        ),
        .library(
            name: "TowerSignalTrace",
            targets: ["TowerSignalTrace"]
        ),
        .library(
            name: "TowerSignalRUM",
            targets: ["TowerSignalRUM"]
        ),
        .library(
            name: "TowerSignalSessionReplay",
            targets: ["TowerSignalSessionReplay"]
        ),
        .library(
            name: "TowerSignalCrashReporting",
            targets: ["TowerSignalCrashReporting"]
        ),
        .library(
            name: "TowerSignalWebViewTracking",
            targets: ["TowerSignalWebViewTracking"]
        ),
        .library(
            name: "TowerSignalFlags",
            targets: ["TowerSignalFlags"]
        ),
        .library(
            name: "TowerSignalProfiling",
            targets: ["TowerSignalProfiling"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/kstenerud/KSCrash.git", from: "2.5.1"),
        .package(url: "https://github.com/open-telemetry/opentelemetry-swift-core", .upToNextMinor(from: "2.5.0")),
    ],
    targets: [
        .target(
            name: "TowerSignalCore",
            dependencies: [
                .target(name: "TowerSignalInternal"),
                .target(name: "TowerSignalPrivate"),
            ],
            path: "TowerSignalCore",
            sources: ["Sources"],
            resources: [
                .copy("Resources/PrivacyInfo.xcprivacy")
            ],
            swiftSettings: [.define("SPM_BUILD")] + internalSwiftSettings
        ),
        .target(
            name: "TowerSignalPrivate",
            path: "TowerSignalCore/Private"
        ),

        .target(
            name: "TowerSignalInternal",
            path: "TowerSignalInternal/Sources",
            swiftSettings: internalSwiftSettings
        ),
        .testTarget(
            name: "TowerSignalInternalTests",
            dependencies: [
                .target(name: "TowerSignalInternal"),
                .target(name: "TestUtilities"),
            ],
            path: "TowerSignalInternal/Tests"
        ),

        .target(
            name: "TowerSignalLogs",
            dependencies: [
                .target(name: "TowerSignalInternal"),
            ],
            path: "TowerSignalLogs/Sources"
        ),
        .testTarget(
            name: "TowerSignalLogsTests",
            dependencies: [
                .target(name: "TowerSignalLogs"),
                .target(name: "TestUtilities"),
            ],
            path: "TowerSignalLogs/Tests"
        ),

        .target(
            name: "TowerSignalTrace",
            dependencies: [
                .target(name: "TowerSignalInternal"),
                .product(name: "OpenTelemetryApi", package: "opentelemetry-swift-core")
            ],
            path: "TowerSignalTrace/Sources",
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ]
        ),
        .testTarget(
            name: "TowerSignalTraceTests",
            dependencies: [
                .target(name: "TowerSignalTrace"),
                .target(name: "TestUtilities"),
            ],
            path: "TowerSignalTrace/Tests",
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ]
        ),

        .target(
            name: "TowerSignalRUM",
            dependencies: [
                .target(name: "TowerSignalInternal"),
                .target(name: "TowerSignalRUMPrivate"),
            ],
            path: "TowerSignalRUM",
            sources: ["Sources"],
            resources: [
                .copy("Resources/PrivacyInfo.xcprivacy")
            ],
            swiftSettings: [.define("SPM_BUILD")] + internalSwiftSettings
        ),
        .target(
            name: "TowerSignalRUMPrivate",
            path: "TowerSignalRUM/Private"
        ),
        .testTarget(
            name: "TowerSignalRUMTests",
            dependencies: [
                .target(name: "TowerSignalRUM"),
                .target(name: "TestUtilities"),
            ],
            path: "TowerSignalRUM/Tests"
        ),

        .target(
            name: "TowerSignalCrashReporting",
            dependencies: [
                .target(name: "TowerSignalInternal"),
                .product(name: "Recording", package: "KSCrash"),
                .product(name: "Filters", package: "KSCrash")
            ],
            path: "TowerSignalCrashReporting",
            sources: ["Sources"],
            resources: [
                .copy("Resources/PrivacyInfo.xcprivacy")
            ]
        ),
        .testTarget(
            name: "TowerSignalCrashReportingTests",
            dependencies: [
                .target(name: "TowerSignalCrashReporting"),
                .target(name: "TestUtilities"),
            ],
            path: "TowerSignalCrashReporting/Tests"
        ),

        .target(
            name: "TowerSignalWebViewTracking",
            dependencies: [
                .target(name: "TowerSignalInternal"),
            ],
            path: "TowerSignalWebViewTracking/Sources"
        ),
        .testTarget(
            name: "TowerSignalWebViewTrackingTests",
            dependencies: [
                .target(name: "TowerSignalWebViewTracking"),
                .target(name: "TestUtilities"),
            ],
            path: "TowerSignalWebViewTracking/Tests"
        ),

        .target(
            name: "TowerSignalSessionReplay",
            dependencies: ["TowerSignalInternal"],
            path: "TowerSignalSessionReplay/Sources"
        ),
        .testTarget(
            name: "TowerSignalSessionReplayTests",
            dependencies: [
                .target(name: "TowerSignalSessionReplay"),
                .target(name: "TestUtilities"),
            ],
            path: "TowerSignalSessionReplay/Tests",
            resources: [
                .process("Resources/Assets.xcassets")
            ]
        ),
        
        .target(
            name: "TowerSignalProfiling",
            dependencies: [
                .target(name: "TowerSignalInternal"),
                .target(name: "TowerSignalMachProfiler")
            ],
            path: "TowerSignalProfiling",
            sources: ["Sources"],
            resources: [
                .copy("Resources/PrivacyInfo.xcprivacy")
            ],
            swiftSettings: internalSwiftSettings
        ),
        .target(
            name: "TowerSignalMachProfiler",
            path: "TowerSignalProfiling/Mach"
        ),
        .testTarget(
            name: "TowerSignalProfilingTests",
            dependencies: [
                .target(name: "TowerSignalMachProfiler"),
                .target(name: "TowerSignalProfiling"),
                .target(name: "TestUtilities"),
            ],
            path: "TowerSignalProfiling/Tests",
            swiftSettings: [.interoperabilityMode(.Cxx)] + internalSwiftSettings
        ),

        .target(
            name: "TowerSignalFlags",
            dependencies: [
                .target(name: "TowerSignalInternal"),
            ],
            path: "TowerSignalFlags/Sources"
        ),
        .testTarget(
            name: "TowerSignalFlagsTests",
            dependencies: [
                .target(name: "TowerSignalFlags"),
                .target(name: "TestUtilities"),
            ],
            path: "TowerSignalFlags/Tests"
        ),

        .target(
            name: "TestUtilities",
            dependencies: [
                .target(name: "TowerSignalCore"),
                .target(name: "TowerSignalPrivate"),
                .target(name: "TowerSignalInternal"),
                .target(name: "TowerSignalLogs"),
                .target(name: "TowerSignalRUM"),
                .target(name: "TowerSignalSessionReplay"),
                .target(name: "TowerSignalTrace"),
                .target(name: "TowerSignalCrashReporting"),
                .target(name: "TowerSignalWebViewTracking"),
                .target(name: "TowerSignalFlags"),
            ],
            path: "TestUtilities/Sources",
            swiftSettings: [.define("SPM_BUILD")] + internalSwiftSettings
        )
    ],
    swiftLanguageModes: [.v5],
    cxxLanguageStandard: .cxx17
)

// If the `AT_TEST_UTILITIES_ENABLED` development ENV is set, export additional utility packages.
// To set this ENV for Xcode projects that fetch this package locally, use `open --env AT_TEST_UTILITIES_ENABLED path/to/<project or workspace>`.
if ProcessInfo.processInfo.environment["AT_TEST_UTILITIES_ENABLED"] != nil {
    package.products.append(
        .library(
            name: "TestUtilities",
            targets: ["TestUtilities"]
        )
    )
}
