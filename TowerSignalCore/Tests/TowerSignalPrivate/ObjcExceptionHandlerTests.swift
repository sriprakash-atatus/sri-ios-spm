/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddCore` -> `TowerSignalCore`; renamed the
// `__dd_private_*` ObjC symbols to `__towersignal_private_*`; rebranded the licence header.

import XCTest
import TowerSignalCore

class ObjcExceptionHandlerTests: XCTestCase {
    func testGivenNonThrowingCode_itDoesNotThrow() throws {
        var counter = 0
        try __towersignal_private_ObjcExceptionHandler.rethrow { counter += 1 }
        XCTAssertEqual(counter, 1)
    }

    func testGivenThrowingCode_itThrowsNSErrorToSwift() {
        let nsException = NSException(
            name: NSExceptionName(rawValue: "name"),
            reason: "reason",
            userInfo: ["user-info": "some"]
        )

        XCTAssertThrowsError(try __towersignal_private_ObjcExceptionHandler.rethrow { nsException.raise() }) { error in
            XCTAssertEqual((error as NSError).domain, "name")
            XCTAssertEqual((error as NSError).code, 0)
            XCTAssertEqual((error as NSError).userInfo as? [String: String], ["user-info": "some"])
        }
    }
}
