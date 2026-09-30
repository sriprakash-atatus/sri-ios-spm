/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddCore` -> `TowerSignalCore`, `ddRUM` ->
// `TowerSignalRUM`, `ddSessionReplay` -> `TowerSignalSessionReplay`; rebranded the `dd` name to `TowerSignal` in
// comments and docs; rebranded the licence header.

import Foundation
import UIKit

import TowerSignalCore
import TowerSignalRUM
import TowerSignalSessionReplay

struct SessionReplayWebViewScenario: Scenario {
    func start(info: TestInfo) -> UIViewController {
        TowerSignal.initialize(
            with: .e2e(info: info),
            trackingConsent: .granted
        )

        RUM.enable(
            with: RUM.Configuration(
                applicationID: info.applicationID,
                uiKitViewsPredicate: DefaultUIKitRUMViewsPredicate(),
                uiKitActionsPredicate: DefaultUIKitRUMActionsPredicate()
            )
        )

        SessionReplay.enable(
            with: SessionReplay.Configuration(
                replaySampleRate: 100,
                textAndInputPrivacyLevel: .maskSensitiveInputs,
                imagePrivacyLevel: .maskNone,
                touchPrivacyLevel: .show
            )
        )

        RUMMonitor.shared().addAttribute(forKey: "scenario", value: "SessionReplayWebView")

        let storyboard = UIStoryboard(name: "SessionReplayWebView", bundle: nil)
        return storyboard.instantiateInitialViewController()!
    }
}
