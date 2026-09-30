/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddCore` -> `TowerSignalCore`, `ddLogs` ->
// `TowerSignalLogs`; rebranded the `dd` name to `TowerSignal` in comments and docs; rebranded the licence
// header.

import Foundation
import SwiftUI

import TowerSignalCore
import TowerSignalLogs

struct LogsCustomScenario: Scenario {
    var initialViewController: UIViewController {
        UIHostingController(rootView: LogsCustomContentView())
    }

    func instrument(with info: AppInfo) {
        TowerSignal.initialize(
            with: .benchmark(info: info),
            trackingConsent: .granted
        )

        Logs.enable()
    }
}
