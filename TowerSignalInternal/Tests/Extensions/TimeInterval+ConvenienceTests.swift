/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; rebranded the
// licence header.

import XCTest
@testable import TowerSignalInternal

final class TimeIntervalConvenienceTests: XCTestCase {
    func test_Seconds() {
        XCTAssertEqual(TimeInterval(30).seconds, 30)
        XCTAssertEqual(Int(30).seconds, 30)
    }

    func test_Minutes() {
        XCTAssertEqual(TimeInterval(2).minutes, 120)
        XCTAssertEqual(Int(2).minutes, 120)
    }

    func test_Hours() {
        XCTAssertEqual(TimeInterval(3).hours, 10_800)
        XCTAssertEqual(Int(2).minutes, 120)
    }

    func test_Days() {
        XCTAssertEqual(TimeInterval(1).days, 86_400)
        XCTAssertEqual(Int(2).minutes, 120)
    }

    func test_Overflow() {
        let timeInterval = TimeInterval.greatestFiniteMagnitude
        XCTAssertEqual(timeInterval.minutes, TimeInterval.greatestFiniteMagnitude)
        XCTAssertEqual(timeInterval.hours, TimeInterval.greatestFiniteMagnitude)
        XCTAssertEqual(timeInterval.days, TimeInterval.greatestFiniteMagnitude)

        let integerTimeInterval = Int.max
        XCTAssertEqual(integerTimeInterval.minutes, TimeInterval.greatestFiniteMagnitude)
        XCTAssertEqual(integerTimeInterval.hours, TimeInterval.greatestFiniteMagnitude)
        XCTAssertEqual(integerTimeInterval.days, TimeInterval.greatestFiniteMagnitude)
    }
}
