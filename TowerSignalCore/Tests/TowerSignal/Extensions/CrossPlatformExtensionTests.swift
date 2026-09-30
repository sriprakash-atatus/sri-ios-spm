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

class CrossPlatformExtensionTests: XCTestCase {
    func testSubscribe_receivesContextUpdates() throws {
        // Given
        let core = TowerSignalCoreProxy()
        CoreRegistry.register(default: core)
        defer { CoreRegistry.unregisterDefault() }

        @ReadWriteLock
        var lastContext: SharedContext?
        CrossPlatformExtension.subscribe { context in
            lastContext = context
        }

        // When
        core.setUserInfo(id: "user-123")
        core.setAccountInfo(id: "account-456")
        try core.flushAndTearDown()

        // Then
        // Verify we eventually get the user and account info
        XCTAssertEqual(lastContext?.userId, "user-123", "Should have user ID in final context")
        XCTAssertEqual(lastContext?.accountId, "account-456", "Should have account ID in final context")
    }
}
