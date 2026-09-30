/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; renamed
// `dd*` types to `TowerSignal*`; renamed the `DD` symbol prefix to `AT`; renamed the `_dd` attribute prefix
// to `_towersignal`; rebranded the `dd` name to `TowerSignal` in comments and docs; rebranded the licence
// header.

import TowerSignalInternal
import Foundation

/// An entry point to TowerSignal RUM feature.
public enum RUM {
    /// Enables TowerSignal RUM feature.
    ///
    /// After RUM is enabled, use `RUMMonitor.shared(in:)` to collect RUM events.
    ///
    /// - Parameters:
    ///   - configuration: Configuration of the feature.
    ///   - core: The instance of TowerSignal SDK to enable RUM in (global instance by default).
    public static func enable(
        with configuration: RUM.Configuration,
        in core: TowerSignalCoreProtocol = CoreRegistry.default
    ) {
        do {
            // To ensure the correct registration order between Core and Features,
            // the entire initialization flow is synchronized on the main thread.
            try runOnMainThreadSync {
                try enableOrThrow(with: configuration, in: core)
            }
        } catch let error {
            consolePrint("\(error)", .error)
        }
    }

    internal static func enableOrThrow(
        with configuration: RUM.Configuration,
        in core: TowerSignalCoreProtocol
    ) throws {
        guard !(core is NOPTowerSignalCore) else {
            throw ProgrammerError(
                description: "TowerSignal SDK must be initialized before calling `RUM.enable(with:)`."
            )
        }

        // Register RUM feature:
        let rum = try RUMFeature(in: core, configuration: configuration)
        try core.register(feature: rum)

        // If resource tracking is configured, register URLSessionHandler to enable network instrumentation:
        if let urlSessionConfig = configuration.urlSessionTracking {
            try RUM._internal.enableURLSessionTracking(with: urlSessionConfig, in: core)
        }

        if configuration.debugViews {
            consolePrint("⚠️ Overriding RUM debugging with AT_DEBUG_RUM launch argument", .warn)
            rum.monitor.debug = true
        }

        // Do initial work:
        rum.monitor.notifySDKInit()
    }
}

extension RUM {
    /// Attributes that can be added to RUM calls that have special properies in TowerSignal.
    public struct Attributes {
        /// Add a custom fingerprint to the RUM error.
        /// The value of this attribute must be a `String`.
        public static let errorFingerprint = "_towersignal.error.fingerprint"
    }
}
