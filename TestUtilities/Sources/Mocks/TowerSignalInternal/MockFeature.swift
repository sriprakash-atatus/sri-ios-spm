/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; renamed
// `dd*` types to `TowerSignal*`; rebranded the licence header.

import Foundation
import TowerSignalInternal

internal class MockFeature: TowerSignalRemoteFeature {
    static var name = "mock-feature"

    var messageReceiver: FeatureMessageReceiver = NOPFeatureMessageReceiver()
    var requestBuilder: FeatureRequestBuilder = MockRequestBuilder()
    var performanceOverride: PerformancePresetOverride?
}

internal class MockRequestBuilder: FeatureRequestBuilder {
    func request(for events: [TowerSignalInternal.Event], with context: TowerSignalInternal.TowerSignalContext, execution: TowerSignalInternal.ExecutionContext) throws -> URLRequest {
        URLRequest.mockAny()
    }
}
