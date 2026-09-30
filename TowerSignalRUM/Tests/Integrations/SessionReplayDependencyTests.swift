/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`, `ddRUM`
// -> `TowerSignalRUM`; renamed `dd*` types to `TowerSignal*`; rebranded the licence header.

import XCTest
import TowerSignalInternal
@testable import TowerSignalRUM

class SessionReplayDependencyTests: XCTestCase {
    func testWhenSessionReplayIsConfigured_itReadsReplayBeingRecorded() throws {
        let hasReplay: Bool = .random()
        let recordsCountByViewID: [String: Int64] = [.mockRandom(): .mockRandom()]

        // When
        let context: TowerSignalContext = .mockWith(
            additionalContext: [
                SessionReplayCoreContext.HasReplay(value: hasReplay),
                SessionReplayCoreContext.RecordsCount(value: recordsCountByViewID)
            ]
        )

        // Then
        XCTAssertEqual(context.hasReplay, hasReplay)
        XCTAssertEqual(context.recordsCountByViewID, recordsCountByViewID)
    }

    func testWhenSessionReplayIsNotConfigured_itReadsNoSRBaggage() {
        // When
        let context: TowerSignalContext = .mockAny()

        // Then
        XCTAssertNil(context.hasReplay)
        XCTAssert(context.recordsCountByViewID.isEmpty)
    }
}
