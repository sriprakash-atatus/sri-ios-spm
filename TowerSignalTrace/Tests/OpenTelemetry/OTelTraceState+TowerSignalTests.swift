/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`,
// `ddTrace` -> `TowerSignalTrace`; rebranded the licence header.

import XCTest
import TestUtilities
import TowerSignalInternal
import OpenTelemetryApi

@testable import TowerSignalTrace

final class OTelTraceStateTowerSignalTests: XCTestCase {
    func testW3C_givenEmptyEntries() throws {
        let traceState = TraceState(entries: [])!
        XCTAssertEqual("", traceState.w3c())
    }

    func testW3C_givenSomeEntries() throws {
        let traceState = TraceState(
            entries: [
                .init(key: "foo", value: "bar")!,
                .init(key: "bar", value: "baz")!
            ]
        )!

        XCTAssertEqual("foo=bar,bar=baz", traceState.w3c())
    }
}
