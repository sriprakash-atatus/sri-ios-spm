/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddCore` -> `TowerSignalCore`, `ddTrace` ->
// `TowerSignalTrace`; rebranded the licence header.

import UIKit
import TowerSignalCore
import TowerSignalTrace

internal class CSRootViewController: UIViewController {
    @IBAction func startCore(_ sender: UIButton) {
        appConfiguration.initializeSDK()
    }

    @IBAction func stopCore(_ sender: UIButton) {
        appConfiguration.deinitializeSDK()
    }
}
