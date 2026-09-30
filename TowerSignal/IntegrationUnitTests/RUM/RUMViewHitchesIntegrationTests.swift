/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`, `ddRUM`
// -> `TowerSignalRUM`; renamed `dd*` types to `TowerSignal*`; rebranded the licence header.

import XCTest
import TestUtilities
@testable import TowerSignalRUM
@testable import TowerSignalInternal

final class RUMViewHitchesIntegrationTests: XCTestCase {
    private var core: TowerSignalCoreProxy! // swiftlint:disable:this implicitly_unwrapped_optional

    override func setUp() {
        super.setUp()
        core = TowerSignalCoreProxy()
    }

    override func tearDownWithError() throws {
        try core.flushAndTearDown()
        core = nil
        super.tearDown()
    }

    func testViewHitchesNotCollected_whenFeatureFlagIsDisabled() throws {
        // Given
        let viewName = "MyView"
        let rumConfig = RUM.Configuration(applicationID: .mockAny(), trackSlowFrames: false)
        RUM.enable(with: rumConfig, in: core)

        let monitor = RUMMonitor.shared(in: core)

        // When
        monitor.startView(key: "key", name: viewName)
        monitor.stopView(key: "key")

        // Then
        let session = try RUMSessionMatcher
            .groupMatchersBySessions(try core.waitAndReturnRUMEventMatchers())
            .takeSingle()

        let customView = try XCTUnwrap(session.views.first(where: { $0.name == viewName }))
        let stopViewEvent = try XCTUnwrap(customView.viewEvents.last) // stopView event
        XCTAssertNil(stopViewEvent.view.slowFrames)
    }

    func testViewHitchesCollected_whenFeatureFlagIsEnabled() throws {
        #if os(watchOS)
        throw XCTSkip("Slow frame tracking is not supported on watchOS (no CADisplayLink)")
        #endif
        // Given
        let viewName = "MyView"
        let rumConfig = RUM.Configuration(applicationID: .mockAny())
        RUM.enable(with: rumConfig, in: core)

        let monitor = RUMMonitor.shared(in: core)

        // When
        monitor.startView(key: "key", name: viewName)

        let completion = expectation(description: "Wait for some slow frames")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // sleep main thread to have some slow frames
            Thread.sleep(forTimeInterval: 0.1)

            // schedule completion to the next runloop
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { completion.fulfill() }
        }

        wait(for: [completion], timeout: 2)

        monitor.stopView(key: "key")

        // Then
        let session = try RUMSessionMatcher
            .groupMatchersBySessions(try core.waitAndReturnRUMEventMatchers())
            .takeSingle()

        let customView = try XCTUnwrap(session.views.first(where: { $0.name == viewName }))
        let stopViewEvent = try XCTUnwrap(customView.viewEvents.last)

        XCTAssertGreaterThan(stopViewEvent.view.slowFrames?.count ?? 0, 0)
    }
}
