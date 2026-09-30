/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddCore` -> `TowerSignalCore`, `ddInternal` ->
// `TowerSignalInternal`; rebranded the licence header.

import XCTest
import TowerSignalInternal
import TestUtilities
@testable import TowerSignalCore

class FeatureContextTests: XCTestCase {
    func testFeatureContextSharing() throws {
        // Given
        let core = TowerSignalCore(
            directory: temporaryCoreDirectory,
            dateProvider: SystemDateProvider(),
            initialConsent: .granted,
            performance: .mockAny(),
            httpClient: HTTPClientMock(),
            encryption: nil,
            contextProvider: .mockAny(),
            applicationVersion: .mockAny(),
            maxBatchesPerUpload: .mockRandom(min: 1, max: 100),
            backgroundTasksEnabled: .mockAny()
        )

        defer { temporaryCoreDirectory.delete() }

        struct ContextMock: AdditionalContext {
            static let key: String = "test"
            let attribute: [String: String]
        }

        // When
        let attributes = ["key": "value"]
        core.set(context: ContextMock(attribute: attributes))

        // Then
        let context = core.contextProvider.read()
        XCTAssertEqual(context.additionalContext(ofType: ContextMock.self)?.attribute, attributes)
    }
}
