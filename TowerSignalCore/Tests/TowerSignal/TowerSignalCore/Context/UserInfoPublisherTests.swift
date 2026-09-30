/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddCore` -> `TowerSignalCore`, `ddInternal` ->
// `TowerSignalInternal`; renamed the `DD` symbol prefix to `AT`; rebranded the licence header.

import XCTest
import TowerSignalInternal
import TestUtilities
@testable import TowerSignalCore

class UserInfoPublisherTests: XCTestCase {
    func testEmptyInitialValue() throws {
        let publisher = UserInfoPublisher()
        ATAssertReflectionEqual(publisher.initialValue, .empty)
    }

    func testPublishUserInfo() throws {
        let expectation = expectation(description: "user info publisher publishes data")

        // Given
        let publisher = UserInfoPublisher()
        let userInfo: UserInfo = .mockRandom()

        // When
        publisher.publish {
            // Then
            ATAssertReflectionEqual($0, userInfo)
            expectation.fulfill()
        }

        publisher.current = userInfo

        // UserInfoPublisher publishes in sync
        waitForExpectations(timeout: 0)
    }
}
