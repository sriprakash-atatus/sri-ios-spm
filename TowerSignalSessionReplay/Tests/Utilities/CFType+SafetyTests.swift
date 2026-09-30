/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddSessionReplay` -> `TowerSignalSessionReplay`;
// rebranded the licence header.

#if os(iOS)
import Foundation
import XCTest
@testable import TowerSignalSessionReplay

class CFTypeSafetyTests: XCTestCase {
    func testInvalidCGColorValueIsSanitized() {
        let valid: CGColor = UIColor.red.cgColor
        XCTAssertEqual(valid, valid.safeCast)

        let string: Any = "invalid CGColor value"
        let invalid = string as! CGColor
        XCTAssertNil(invalid.safeCast)
    }
}
#endif
