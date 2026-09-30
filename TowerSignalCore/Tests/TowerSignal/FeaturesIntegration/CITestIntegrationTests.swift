/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddCore` -> `TowerSignalCore`; rebranded the licence
// header.

@testable import TowerSignalCore
import XCTest

class CITestIntegrationTests: XCTestCase {
    func testByDefaultCITestIntegrationIsNotConfigured() throws {
        XCTAssertNil(CITestIntegration.active)
    }
}
