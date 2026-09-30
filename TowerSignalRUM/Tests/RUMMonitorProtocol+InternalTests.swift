/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`, `ddRUM`
// -> `TowerSignalRUM`; rebranded the licence header.

import XCTest
import TowerSignalInternal
import TestUtilities
@testable import TowerSignalRUM

class RUMMonitorProtocol_InternalTests: XCTestCase {
    func testInternalInterfaceIsAvailableOnMonitor() {
        let monitor: RUMMonitorProtocol

        // When
        monitor = Monitor(
            dependencies: .mockAny(),
            dateProvider: SystemDateProvider()
        )

        // Then
        XCTAssertIdentical(monitor._internal?.monitor, monitor)
    }

    func testInternalInterfaceIsNotAvailableOnNOPMonitor() {
        let monitor: RUMMonitorProtocol

        // When
        monitor = NOPMonitor()

        // Then
        XCTAssertNil(monitor._internal)
    }
}
