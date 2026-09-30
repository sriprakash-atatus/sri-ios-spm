/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`,
// `ddMachProfiler` -> `TowerSignalMachProfiler`; renamed `dd*` types to `TowerSignal*`; rebranded the
// `dd` name to `TowerSignal` in comments and docs; rebranded the licence header.

import Foundation
import TowerSignalInternal

#if !os(watchOS)

// swiftlint:disable duplicate_imports
#if swift(>=6.0)
internal import TowerSignalMachProfiler
#else
@_implementationOnly import TowerSignalMachProfiler
#endif
// swiftlint:enable duplicate_imports

/// Main entry point for TowerSignal profiling functionality.
///
/// The `Profiling` provides static methods to configure, enable profiling.
/// It captures performance data in pprof format and sends it to TowerSignal for analysis.
public enum Profiling {
    /// Enables profiling with the specified configuration.
    /// 
    /// This method registers the profiling feature with the TowerSignal core, setting up
    /// the necessary components.
    /// 
    /// - Parameters:
    ///   - configuration: The profiling configuration to use.
    ///   - core: The TowerSignal core instance to register with. Defaults to the default core.
    @available(*, message: "This API is experimental and may change in future releases")
    public static func enable(with configuration: Configuration = .init(), in core: TowerSignalCoreProtocol = CoreRegistry.default) {
        let telemetryController = ProfilingTelemetryController(
            sampleRate: configuration.debugSDK ? 100 : ProfilingTelemetryController.defaultSampleRate,
            telemetry: core.telemetry
        )
        try? core.register(
            feature: ProfilerFeature(
                core: core,
                configuration: configuration,
                requestBuilder: RequestBuilder(
                    customUploadURL: configuration.customEndpoint,
                    telemetry: core.telemetry
                ),
                telemetryController: telemetryController
            )
        )

        core.set(context: ProfilingContext(status: .current))
    }
}

#endif
