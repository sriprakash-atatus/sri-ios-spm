/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; rebranded the
// licence header.

import XCTest
@testable import TowerSignalInternal

class SpanIDGeneratorTests: XCTestCase {
    func testDefaultGenerationBoundaries() {
        let generator = DefaultSpanIDGenerator()
        XCTAssertEqual(generator.range.lowerBound, 1)
        XCTAssertEqual(generator.range.upperBound, 9_223_372_036_854_775_807) // 2 ^ 63 -1
    }

    func testItGeneratesUUIDsFromGivenBoundaries() {
        let generator = DefaultSpanIDGenerator(range: 10...15)
        var generatedUUIDs: Set<SpanID> = []

        (0..<1_000).forEach { _ in
            generatedUUIDs.insert(generator.generate())
        }

        XCTAssertEqual(generatedUUIDs, [10, 11, 12, 13, 14, 15])
    }
}
