/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; rebranded the
// licence header.

import XCTest
import TowerSignalInternal

class BundleTypeTests: XCTestCase {
    func testiOSAppBundleType() {
        let bundle: Bundle = .mockWith(bundlePath: "bundle.path.app")
        let bundleType = BundleType(bundle: bundle)
        XCTAssertEqual(bundleType, .iOSApp)
    }

    func testiOSAppExtensionBundleType() {
        let bundle: Bundle = .mockWith(bundlePath: "bundle.path.appex")
        let bundleType = BundleType(bundle: bundle)
        XCTAssertEqual(bundleType, .iOSAppExtension)
    }
}
