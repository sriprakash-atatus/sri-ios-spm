/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddSessionReplay` -> `TowerSignalSessionReplay`;
// rebranded the licence header.

#if os(iOS)
import XCTest

@testable import TowerSignalSessionReplay
@testable import TestUtilities

// swiftlint:disable empty_xctest_method
class RecordsWriterTests: XCTestCase {
    func testWhenFeatureScopeIsConnected_itWritesRecordsToCore() {
        // Given
        let core = PassthroughCoreMock()

        // When
        let writer = RecordWriter(core: core)

        // Then
        writer.write(nextRecord: EnrichedRecord(context: .mockRandom(), records: .mockRandom()))
        writer.write(nextRecord: EnrichedRecord(context: .mockRandom(), records: .mockRandom()))
        writer.write(nextRecord: EnrichedRecord(context: .mockRandom(), records: .mockRandom()))

        XCTAssertEqual(core.events(ofType: EnrichedRecord.self).count, 3)
    }

    func testWhenFeatureScopeIsNotConnected_itDoesNotWriteRecordsToCore() throws {
        // Given
        let core = SingleFeatureCoreMock<MockFeature>()
        let feature = MockFeature()
        try core.register(feature: feature)

        // When
        let writer = RecordWriter(core: core)

        // Then
        writer.write(nextRecord: EnrichedRecord(context: .mockRandom(), records: .mockRandom()))

        XCTAssertEqual(core.events(ofType: EnrichedRecord.self).count, 0)
    }
}
// swiftlint:enable empty_xctest_method
#endif
