// ATCHG: TowerSignal SDK migration - renamed module imports `ddRUM` -> `TowerSignalRUM`; repointed the intake
// host at the TowerSignal site; rebranded the `dd` name to `TowerSignal` in comments and docs.

// Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
// This product includes software developed at TowerSignal (https://www.towersignal.com/).
// Copyright 2026-Present TowerSignal, Inc.

import UIKit
import TowerSignalRUM

internal class KioskSendEventsViewController: UIViewController {
    @IBOutlet private var doneButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()

        doneButton.isHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        rumMonitor.startView(viewController: self, name: "KioskSendEvents")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        rumMonitor.stopView(viewController: self)
    }

    @IBAction func didTapDownloadResourceButton(_ sender: UIButton) {
        rumMonitor.addAction(
            type: .tap,
            name: sender.currentTitle!,
            attributes: ["button.description": String(describing: sender)]
        )

        let simulatedResourceKey = "/resource/1"
        let simulatedResourceRequest = URLRequest(url: URL(string: "https://foo.com/resource/1")!)
        let simulatedResourceLoadingTime: TimeInterval = 0.5

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

            // Reveal "Done" so UITest can continue
            self.doneButton.isHidden = false
        }
    }
}
