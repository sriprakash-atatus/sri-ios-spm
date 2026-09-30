/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddCore` -> `TowerSignalCore`, `ddRUM` ->
// `TowerSignalRUM`; rebranded the `dd` name to `TowerSignal` in comments and docs; rebranded the licence header.

import TowerSignalCore
import TowerSignalRUM
import SwiftUI

struct RUMAutoScenario: Scenario {
    var initialViewController: UIViewController {
        UIHostingController(rootView: RUMAutoContentView())
    }

    func instrument(with info: AppInfo) {
        TowerSignal.initialize(
            with: .benchmark(info: info),
            trackingConsent: .granted
        )

        RUM.enable(
            with: RUM.Configuration(
                applicationID: info.applicationID,
                uiKitViewsPredicate: DefaultUIKitRUMViewsPredicate(),
                uiKitActionsPredicate: DefaultUIKitRUMActionsPredicate(),
                swiftUIViewsPredicate: DefaultSwiftUIRUMViewsPredicate(),
                swiftUIActionsPredicate: DefaultSwiftUIRUMActionsPredicate(isLegacyDetectionEnabled: true)
            )
        )

        RUMMonitor.shared().addAttribute(forKey: "scenario", value: "RUMAuto")
    }
}
