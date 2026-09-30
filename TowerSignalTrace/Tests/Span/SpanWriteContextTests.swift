/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`,
// `ddTrace` -> `TowerSignalTrace`; renamed `dd*` types to `TowerSignal*`; renamed the `DD` symbol prefix to
// `AT`; rebranded the licence header.

import XCTest
import TestUtilities
import TowerSignalInternal
@testable import TowerSignalTrace

class SpanWriteContextTests: XCTestCase {
    private let featureScope = FeatureScopeMock()

    @MainActor
    func testWhenRequestingSpanWriteContext_itProvidesInitialCoreContext() {
        let retrieveContext = expectation(description: "provide core context")

        let initialContext: TowerSignalContext = .mockRandom()
        featureScope.contextMock = initialContext

        // Given
        let writer = LazySpanWriteContext(featureScope: featureScope)

        // When
        featureScope.contextMock = .mockRandom()

        writer.spanWriteContext { providedContext, _ in
            // Then
            ATAssertReflectionEqual(providedContext, initialContext)
            retrieveContext.fulfill()
        }

        waitForExpectations(timeout: 0.5)
    }

    func testWhenWritingEvent_itDoesNotBypassConsent() {
        // Given
        let writer = LazySpanWriteContext(featureScope: featureScope)

        // When
        writer.spanWriteContext { _, writer in
            writer.write(value: SpanEvent.mockAny())
        }

        // Then
        XCTAssertEqual(featureScope.eventsWritten(ofType: SpanEvent.self, withBypassConsent: false).count, 1)
        XCTAssertEqual(featureScope.eventsWritten(ofType: SpanEvent.self, withBypassConsent: true).count, 0)
    }
}
