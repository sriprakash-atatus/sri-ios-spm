/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports from `dd*` to `TowerSignal*`; renamed `dd*`
// types to `TowerSignal*`; rebranded the `dd` name to `TowerSignal` in comments and docs; scrubbed the remaining
// `dd` name to `dd` in comments and docs; rebranded the licence header.

#if canImport(ddSDKTesting)
@_exported import ddSDKTesting
#else
import Testing

/// No-op stand-in for `ddSDKTesting`'s `.towersignalTesting` trait.
///
/// `ddSDKTesting` (https://github.com/dd/dd-sdk-swift-testing) requires iOS 15+,
/// while this package's platform floor is iOS 12 — SwiftPM has no per-target deployment
/// override, so it can't be declared as a `Package.swift` dependency. It is only ever
/// resolved when building through `TowerSignal.xcworkspace`, which links it directly. When
/// building via `Package.swift` (`swift build`/`swift test`), this stub is used instead so
/// `@Suite(.towersignalTesting)` still compiles, without observing anything.
public struct TowerSignalSDKTestingStubTrait: TestTrait, SuiteTrait {
    public let isRecursive = true
}

extension Trait where Self == TowerSignalSDKTestingStubTrait {
    public static var towersignalTesting: Self { Self() }
}

/// Stand-in for `ddSDKTesting`'s `Tag.dd.retriable`/`.nonretriable` and
/// `Tag.dd.tia.skippable`/`.unskippable` tags. Applying any of these tags under the
/// stub is a no-op.
extension Tag {
    public enum dd {
        @Tag public static var retriable: Tag
        @Tag public static var nonretriable: Tag

        public enum tia {
            @Tag public static var skippable: Tag
            @Tag public static var unskippable: Tag
        }
    }
}
#endif
