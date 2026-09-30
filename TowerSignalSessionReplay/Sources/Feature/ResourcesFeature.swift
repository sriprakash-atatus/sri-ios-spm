/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; renamed
// `dd*` types to `TowerSignal*`; rebranded the licence header.

#if os(iOS)
import Foundation
import TowerSignalInternal

internal class ResourcesFeature: TowerSignalRemoteFeature {
    static var name = "session-replay-resources"

    let messageReceiver: FeatureMessageReceiver = NOPFeatureMessageReceiver()
    let performanceOverride: PerformancePresetOverride?

    let requestBuilder: FeatureRequestBuilder

    init(
        core: TowerSignalCoreProtocol,
        configuration: SessionReplay.Configuration
    ) {
        self.requestBuilder = ResourceRequestBuilder(
            customUploadURL: configuration.customEndpoint,
            telemetry: core.telemetry
        )
        self.performanceOverride = PerformancePresetOverride(
            maxFileSize: SessionReplay.maxObjectSize,
            maxObjectSize: SessionReplay.maxObjectSize
        )
    }
}
#endif
