/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddCore` -> `TowerSignalCore`, `ddProfiling` ->
// `TowerSignalProfiling`, `ddRUM` -> `TowerSignalRUM`; rebranded the `dd` name to `TowerSignal` in comments and
// docs; rebranded the licence header.

import Foundation
import SwiftUI

import TowerSignalCore
import TowerSignalRUM
import TowerSignalProfiling

struct ProfilingScenario: Scenario {
    var initialViewController: UIViewController {
        UIHostingController(rootView: ProfilingContentView())
    }

    func instrument(with info: AppInfo) {
        TowerSignal.initialize(
            with: .benchmark(info: info),
            trackingConsent: .granted
        )

        RUM.enable(
            with: RUM.Configuration(
                applicationID: info.applicationID,
                longTaskThreshold: 0.1,
                appHangThreshold: 0.4
            )
        )

        RUMMonitor.shared().addAttribute(forKey: "scenario", value: "ContinuousProfiling")

        Profiling.enable(with: .init(applicationLaunchSampleRate: .maxSampleRate, continuousSampleRate: .maxSampleRate))
    }
}
