/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddCore` -> `TowerSignalCore`, `ddInternal` ->
// `TowerSignalInternal`; renamed `dd*` types to `TowerSignal*`; rebranded the licence header.

import XCTest
import TowerSignalInternal
import TestUtilities
@_spi(Internal)
@testable import TowerSignalCore

class ContextSharingTransformerTests: XCTestCase {
    private var core: TowerSignalCoreProxy! // swiftlint:disable:this implicitly_unwrapped_optional

    override func setUp() {
        super.setUp()
        core = TowerSignalCoreProxy()
    }

    override func tearDownWithError() throws {
        try core.flushAndTearDown()
        core = nil
        try super.tearDownWithError()
    }

    func testReceiveContextMessage_transformsToSharedContext() throws {
        // Given
        let transformer = ContextSharingTransformer()
        let message = FeatureMessage.context(.mockRandom())

        // When
        let handled = transformer.receive(message: message, from: core)

        // Then
        XCTAssertTrue(handled)
    }

    func testReceiveNonContextMessage_returnsNotHandled() throws {
        // Given
        let transformer = ContextSharingTransformer()
        let customMessage = FeatureMessage.payload("")

        // When
        let handled = transformer.receive(message: customMessage, from: core)

        // Then
        XCTAssertFalse(handled)
    }

    func testPublish_callsReceiverImmediately() throws {
        // Given
        let transformer = ContextSharingTransformer()
        var receiverCalled = false
        var receivedContext: SharedContext?

        // When
        transformer.publish { context in
            receiverCalled = true
            receivedContext = context
        }

        // Then - receiver must be called synchronously within `publish`
        XCTAssertTrue(receiverCalled)
        XCTAssertNil(receivedContext) // Initially nil
    }

    func testPublish_callsReceiverOnContextUpdate() throws {
        // Given
        let transformer = ContextSharingTransformer()
        var receivedContexts: [SharedContext?] = []

        transformer.publish { context in
            receivedContexts.append(context)
        }

        // When
        let userInfo = UserInfo(id: "user-456")
        let accountInfo = AccountInfo(id: "account-789")
        let context = TowerSignalContext.mockWith(userInfo: userInfo, accountInfo: accountInfo)
        let message = FeatureMessage.context(context)
        _ = transformer.receive(message: message, from: core)

        // Then
        XCTAssertEqual(receivedContexts.count, 2)
        XCTAssertNil(receivedContexts[0])
        XCTAssertEqual(receivedContexts[1]?.userId, "user-456")
        XCTAssertEqual(receivedContexts[1]?.accountId, "account-789")
    }

    func testCancel_removesReceiver() throws {
        // Given
        let transformer = ContextSharingTransformer()
        var callCount = 0

        transformer.publish { _ in
            callCount += 1
        }

        // When
        transformer.cancel()

        let context = TowerSignalContext.mockWith(userInfo: UserInfo(id: "user-789"))
        let message = FeatureMessage.context(context)
        _ = transformer.receive(message: message, from: core)

        // Then - receiver must not be called after cancel
        XCTAssertEqual(callCount, 1) // Only initial call from publish
    }
}
