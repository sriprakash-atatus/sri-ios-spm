/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddCore` -> `TowerSignalCore`, `ddLogs` ->
// `TowerSignalLogs`, `ddRUM` -> `TowerSignalRUM`, `ddSessionReplay` -> `TowerSignalSessionReplay`,
// `ddTrace` -> `TowerSignalTrace`; rebranded the licence header.

import XCTest
@testable import TowerSignalCore
@testable import TowerSignalRUM
@testable import TowerSignalLogs
@testable import TowerSignalTrace
#if os(iOS)
@testable import TowerSignalSessionReplay
#endif

class CoreMetricsIntegrationTests: XCTestCase {
    func testResolvingTrackValueFromFeatureName() {
        XCTAssertEqual(BatchMetric.trackValue(for: RUMFeature.name), "rum")
        XCTAssertEqual(BatchMetric.trackValue(for: TraceFeature.name), "trace")
        XCTAssertEqual(BatchMetric.trackValue(for: LogsFeature.name), "logs")
#if os(iOS)
        XCTAssertEqual(BatchMetric.trackValue(for: SessionReplayFeature.name), "sr")
        XCTAssertEqual(BatchMetric.trackValue(for: ResourcesFeature.name), "sr-resources")
#endif
    }
}
