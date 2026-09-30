/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; repointed the
// intake host at the TowerSignal site; rebranded the licence header.

import XCTest

@testable import TowerSignalInternal

class URLSessionTaskSwizzlerTests: XCTestCase {
    func testSwizzling_taskResume() throws {
        let expectation = self.expectation(description: "resume")

        // Given
        let swizzler = URLSessionTaskSwizzler()

        try swizzler.swizzle(
            interceptResume: { _ in
                expectation.fulfill()
            }
        )

        // When
        let session = URLSession(configuration: .ephemeral)
        let url = URL(string: "https://www.towersignal.com/")!
        session
            .dataTask(with: url)
            .resume() // intercepted

        swizzler.unswizzle()

        session
            .dataTask(with: url)
            .resume() // not intercepted

        // Then
        wait(for: [expectation], timeout: 5)
    }
}
