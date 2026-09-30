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

class OTelTraceIdTowerSignalTests: XCTestCase {
    func testToTowerSignal_onlyHigherOrderBitsAreConsidered() {
        let otelId = TraceId.random()
        let atId = otelId.toTowerSignal()
        XCTAssertEqual(otelId.idLo, atId.idLo)
        XCTAssertEqual(otelId.idHi, atId.idHi)
    }
}
