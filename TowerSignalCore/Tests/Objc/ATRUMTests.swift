/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`, `ddRUM`
// -> `TowerSignalRUM`; renamed the `DD` symbol prefix to `AT`; rebranded the licence header.

import XCTest
import TestUtilities
import TowerSignalInternal
@_spi(objc)
@testable import TowerSignalRUM

class ATRUMTests: XCTestCase {
    private var core: FeatureRegistrationCoreMock! // swiftlint:disable:this implicitly_unwrapped_optional

    override func setUp() {
        super.setUp()
        core = FeatureRegistrationCoreMock()
        CoreRegistry.register(default: core)
    }

    override func tearDown() {
        CoreRegistry.unregisterDefault()
        core = nil
        super.tearDown()
    }

    func testWhenNotEnabled() {
        XCTAssertTrue(objc_RUMMonitor.shared().swiftRUMMonitor is NOPMonitor)
    }

    func testWhenEnabled() {
        objc_RUM.enable(with: objc_RUMConfiguration(applicationID: "app-id"))
        XCTAssertTrue(objc_RUMMonitor.shared().swiftRUMMonitor is Monitor)
    }
}
