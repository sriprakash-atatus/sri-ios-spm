// ATCHG: TowerSignal SDK migration - renamed module imports `ddRUM` -> `TowerSignalRUM`; repointed the intake
// host at the TowerSignal site; rebranded the `dd` name to `TowerSignal` in comments and docs.

// Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
// This product includes software developed at TowerSignal (https://www.towersignal.com/).
// Copyright 2026-Present TowerSignal, Inc.

import UIKit
import TowerSignalRUM

internal class KioskSendInterruptedEventsViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        rumMonitor.startView(viewController: self, name: "KioskSendInterruptedEvents")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        rumMonitor.stopView(viewController: self)
    }

    @IBAction func didTapDownloadResourceButton(_ sender: Any) {
        rumMonitor.addAction(
            type: .tap,
            name: (sender as! UIButton).currentTitle!,
            attributes: ["button.description": String(describing: sender)]
        )

        let simulatedResourceKey = "/resource/1"
        let simulatedResourceRequest = URLRequest(url: URL(string: "https://foo.com/resource/1")!)
        // Much longer wait time
        let simulatedResourceLoadingTime: TimeInterval = 1.0

        rumMonitor.startResource(
            resourceKey: simulatedResourceKey,
            request: simulatedResourceRequest
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + simulatedResourceLoadingTime) {
            rumMonitor.stopResource(
                resourceKey: simulatedResourceKey,
                response: HTTPURLResponse(
                    url: simulatedResourceRequest.url!,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: ["Content-Type": "image/png"]
                )!
            )
        }
    }
}
