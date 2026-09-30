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

class SharedContextTests: XCTestCase {
    func testInitializationWithTowerSignalContext_withNilAccountAndUserInfo_setsNilIds() throws {
        // Given
        let context = TowerSignalContext.mockWith(userInfo: nil, accountInfo: nil)

        // When
        let sharedContext = SharedContext(towersignalContext: context)

        // Then
        XCTAssertNil(sharedContext.userId)
        XCTAssertNil(sharedContext.accountId)
    }

    func testInitializationWithTowerSignalContext_withCompleteContext() throws {
        // Given
        let context = TowerSignalContext.mockWith(
            userInfo: UserInfo(
                id: "user-789"
            ),
            accountInfo: AccountInfo(
                id: "account-999"
            )
        )

        // When
        let sharedContext = SharedContext(towersignalContext: context)

        // Then
        XCTAssertEqual(sharedContext.userId, "user-789")
        XCTAssertEqual(sharedContext.accountId, "account-999")
    }
}
