/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`,
// `ddTrace` -> `TowerSignalTrace`; renamed `dd*` members to `at*`; rebranded the licence header.

import XCTest
import TestUtilities
import TowerSignalInternal
import OpenTelemetryApi

@testable import TowerSignalTrace

class OTelSpanIdTowerSignalTests: XCTestCase {
    func testToTowerSignal() {
        let otelId = SpanId.random()
        let atId = otelId.toTowerSignal()
        XCTAssertEqual(otelId.rawValue, atId.rawValue)
    }
}
