/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`,
// `ddProfiling` -> `TowerSignalProfiling`; renamed the `DD` symbol prefix to `AT`; rebranded the licence
// header.

#if !os(watchOS)
import XCTest
import TowerSignalInternal
import TestUtilities

@testable import TowerSignalProfiling

class ProfileEventTests: XCTestCase {
    func testEncoding() {
        let additionalAttribues = mockRandomAttributes()

        let event = ProfileEvent(
            family: "family",
            runtime: "runtime",
            version: "version",
            start: .mockAny(),
            end: .mockAny(),
            attachments: ["attachment"],
            tags: "tag:tag",
            additionalAttributes: additionalAttribues
        )

        let expected: [String: Encodable] = [
            "family": "family",
            "runtime": "runtime",
            "version": "version",
            "start": Date.mockAny(),
            "end": Date.mockAny(),
            "attachments": ["attachment"],
            "tags_profiler": "tag:tag",
        ].merging(additionalAttribues, uniquingKeysWith: { $1 })

        ATAssertJSONEqual(event, expected)
    }
}
#endif // !os(watchOS)
