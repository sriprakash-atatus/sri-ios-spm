/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; repointed the
// intake host at the TowerSignal site; rebranded the licence header.

import XCTest

import TestUtilities
@testable import TowerSignalInternal

class URLSessionTaskDelegateSwizzlerTests: XCTestCase {
    func testSwizzling_implementedMethods() throws {
        let delegate = SessionTaskDelegateMock()
        let didFinishCollecting = expectation(description: "didFinishCollecting")
        let didCompleteWithError = expectation(description: "didCompleteWithError")

        // Given
        let swizzler = URLSessionTaskDelegateSwizzler()

        try swizzler.swizzle(
            delegateClass: SessionTaskDelegateMock.self,
            interceptDidFinishCollecting: { _, _, _ in
                didFinishCollecting.fulfill()
            },
            interceptDidCompleteWithError: { _, _, _ in
                didCompleteWithError.fulfill()
            }
        )

        // When
        let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
        let url = URL(string: "https://www.towersignal.com/")!
        session
            .dataTask(with: url)
            .resume() // intercepted

        wait(for: [didFinishCollecting, didCompleteWithError], timeout: 5)
    }

    func testSwizzling_whenMethodsNotImplemented() throws {
        let delegate = SessionDataDelegateMock()
        let didFinishCollecting = expectation(description: "didFinishCollecting")
        let didCompleteWithError = expectation(description: "didCompleteWithError")

        // Given
        let swizzler = URLSessionTaskDelegateSwizzler()

        try swizzler.swizzle(
            delegateClass: SessionDataDelegateMock.self,
            interceptDidFinishCollecting: { _, _, _ in
                didFinishCollecting.fulfill()
            },
            interceptDidCompleteWithError: { _, _, _ in
                didCompleteWithError.fulfill()
            }
        )

        // When
        let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
        let url = URL(string: "https://www.towersignal.com/")!
        session
            .dataTask(with: url)
            .resume() // intercepted

        wait(for: [didFinishCollecting, didCompleteWithError], timeout: 5)
    }

    func testUnSwizzling() throws {
        let delegate = SessionDataDelegateMock()
        let expectation = self.expectation(description: "not expected")
        expectation.isInverted = true

        // Given
        let swizzler = URLSessionTaskDelegateSwizzler()

        try swizzler.swizzle(
            delegateClass: SessionDataDelegateMock.self,
            interceptDidFinishCollecting: { _, _, _ in
                expectation.fulfill()
            },
            interceptDidCompleteWithError: { _, _, _ in
                expectation.fulfill()
            }
        )

        // When
        let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
        let url = URL(string: "https://www.towersignal.com/")!
        session
            .dataTask(with: url)
            .resume() // not intercepted

        swizzler.unswizzle()

        waitForExpectations(timeout: 5)
    }
}
