/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`,
// `ddTrace` -> `TowerSignalTrace`; renamed the `DD` symbol prefix to `AT`; rebranded the licence header.

import XCTest
import TestUtilities
import TowerSignalInternal

@testable import TowerSignalTrace

class WarningsTests: XCTestCase {
    func testPrintingWarningsOnDifferentConditions() {
        let core = PassthroughCoreMock()

        let dd = AT.mockWith(logger: CoreLoggerMock())
        defer { dd.reset() }

        XCTAssertTrue(warn(if: true, message: "message"))
        XCTAssertEqual(dd.logger.warnLog?.message, "message")

        dd.logger.reset()

        XCTAssertFalse(warn(if: false, message: "message"))
        XCTAssertNil(dd.logger.warnLog)

        dd.logger.reset()

        let failingCast: () -> ATSpan? = { warnIfCannotCast(value: ATNoopSpan()) }
        XCTAssertNil(failingCast())
        XCTAssertEqual(dd.logger.warnLog?.message, "🔥 Using ATNoopSpan while ATSpan was expected.")

        dd.logger.reset()

        let succeedingCast: () -> ATSpan? = { warnIfCannotCast(value: ATSpan.mockAny(in: core)) }
        XCTAssertNotNil(succeedingCast())
        XCTAssertNil(dd.logger.warnLog)
    }
}
