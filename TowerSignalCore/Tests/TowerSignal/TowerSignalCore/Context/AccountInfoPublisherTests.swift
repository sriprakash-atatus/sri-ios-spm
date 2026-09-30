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

class AccountInfoPublisherTests: XCTestCase {
    func testNilInitialValue() throws {
        let publisher = AccountInfoPublisher()
        ATAssertReflectionEqual(publisher.initialValue, nil)
    }

    func testPublishAccountInfo() throws {
        let expectation = expectation(description: "account info publisher publishes data")

        // Given
        let publisher = AccountInfoPublisher()
        let accountInfo: AccountInfo = .mockRandom()

        // When
        publisher.publish {
            // Then
            ATAssertReflectionEqual($0, accountInfo)
            expectation.fulfill()
        }

        publisher.current = accountInfo

        // AccountInfoPublisher publishes in sync
        waitForExpectations(timeout: 0)
    }
}
