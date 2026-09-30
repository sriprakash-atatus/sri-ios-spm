/*
* Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
* This product includes software developed at TowerSignal (https://www.towersignal.com/).
* Copyright 2026-Present TowerSignal, Inc.
*/

// ATCHG: TowerSignal SDK migration - renamed module imports `ddFlags` -> `TowerSignalFlags`, `ddProfiling`
// -> `TowerSignalProfiling`, `ddRUM` -> `TowerSignalRUM`, `ddSessionReplay` -> `TowerSignalSessionReplay`,
// `ddTrace` -> `TowerSignalTrace`; renamed `dd*` types to `TowerSignal*`; rebranded the licence header.

import UIKit
import TowerSignalRUM
import TowerSignalSessionReplay // it should compile for iOS and tvOS, but APIs are only available on iOS
import TowerSignalTrace
import TowerSignalFlags
import TowerSignalProfiling
@preconcurrency import OpenTelemetryApi

internal class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        TowerSignalSetup.initialize()

        // RUM APIs must be visible:
        RUM.enable(
            with: .init(
                applicationID: "app-id",
                onSessionStart: { sessionID, _ in
                    print("Session ID is \(sessionID)")
                }
            )
        )
        RUMMonitor.shared().startView(viewController: self)

        // Trace APIs must be visible:
        Trace.enable()
        OpenTelemetry.registerTracerProvider(
            tracerProvider: OTelTracerProvider()
        )

        let otSpan = Tracer.shared().startSpan(operationName: "OT Span")
        otSpan.finish()
        
        // otel tracer
        let tracer = OpenTelemetry
            .instance
            .tracerProvider
            .get(instrumentationName: "", instrumentationVersion: nil)
        let otelSpan = tracer.spanBuilder(spanName: "OTel span").startSpan()
        otelSpan.end()

        #if os(iOS)
        // Session Replay API must be visible:
        SessionReplay.enable(with: .init(replaySampleRate: 0))
        #endif

        addLabel()
    }

    private func addLabel() {
        let label = UILabel()
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(label)

        label.text = "Testing..."
        label.textColor = .white
        label.sizeToFit()
        label.center = view.center
    }
}
