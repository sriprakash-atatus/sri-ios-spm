/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddTrace` -> `TowerSignalTrace`; rebranded the
// licence header.

import XCTest
import TowerSignalTrace

class TraceConfigurationTests: XCTestCase {
    func testDefaultConfiguration() {
        // When
        let config = Trace.Configuration()

        // Then
        XCTAssertEqual(config.sampleRate, 100)
        XCTAssertNil(config.service)
        XCTAssertNil(config.tags)
        XCTAssertNil(config.urlSessionTracking)
        XCTAssertTrue(config.bundleWithRumEnabled)
        XCTAssertFalse(config.networkInfoEnabled)
        XCTAssertNil(config.eventMapper)
        XCTAssertNil(config.customEndpoint)
    }

    func testDefaultURLSessionTrackingConfiguration() {
        // When
        let tracking = Trace.Configuration.URLSessionTracking(
            firstPartyHostsTracing: .trace(hosts: [])
        )

        // Then
        XCTAssertEqual(tracking.redactedStatusCodes, [404])
    }
}
