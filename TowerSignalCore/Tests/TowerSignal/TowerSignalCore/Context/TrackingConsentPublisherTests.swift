/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddCore` -> `TowerSignalCore`; rebranded the licence
// header.

import XCTest
@testable import TowerSignalCore

class TrackingConsentPublisherTests: XCTestCase {
    func testInitialValue() throws {
        let publisher = TrackingConsentPublisher(consent: .pending)
        XCTAssertEqual(publisher.initialValue, .pending)
    }

    func testPublishTrackingConsent() throws {
        let expectation = expectation(description: "tracking consenr publisher publishes data")

        // Given
        let publisher = TrackingConsentPublisher(consent: .granted)

        // When
        publisher.publish {
            // Then
            XCTAssertEqual($0, .notGranted)
            expectation.fulfill()
        }

        publisher.consent = .notGranted

        // TrackingConsentPublisher publishes in sync
        waitForExpectations(timeout: 0)
    }
}
