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

@testable import TowerSignalTrace

class ContextMessageReceiverTests: XCTestCase {
    func testItReceivesApplicationStateHistory() throws {
        // Given
        let receiver = ContextMessageReceiver(samplerProvider: SamplerProvider(sampleRate: .mockAny()))
        let core = PassthroughCoreMock(
            context: .mockWith(applicationStateHistory: .mockAppInBackground()),
            messageReceiver: receiver
        )

        XCTAssertEqual(receiver.context.applicationStateHistory?.currentState, .background)

        // When
        core.context.applicationStateHistory.append(state: .active, at: Date())

        // Then
        XCTAssertEqual(receiver.context.applicationStateHistory?.currentState, .active)
    }
}
