/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddRUM` -> `TowerSignalRUM`; rebranded the licence
// header.

import UIKit
import TowerSignalRUM

internal class SendRUMFixture3ViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        rumMonitor.startView(key: "fixture3-vc", name: "SendRUMFixture3View")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            rumMonitor.addError(
                message: "Simulated view error with fingerprint",
                source: .source, 
                attributes: [
                    RUM.Attributes.errorFingerprint: "fake-fingerprint"
                ]
            )
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        rumMonitor.stopView(key: "fixture3-vc")
    }
}
