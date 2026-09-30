/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddCore` -> `TowerSignalCore`, `ddTrace` ->
// `TowerSignalTrace`; rebranded the `dd` name to `TowerSignal` in comments and docs; rebranded the licence
// header.

import Foundation
import UIKit
import TowerSignalTrace
import TowerSignalCore
import OpenTelemetryApi

struct TraceScenario: Scenario {
    func start(info: TestInfo) -> UIViewController {
        TowerSignal.verbosityLevel = .debug

        TowerSignal.initialize(
            with: .e2e(info: info),
            trackingConsent: .granted
        )

        Trace.enable(
            with: .init(
                urlSessionTracking: .init(
                    firstPartyHostsTracing: .trace(
                        hosts: ["httpbin.org"],
                        sampleRate: 100,
                        traceControlInjection: .all
                    )
                )
            )
        )

        OpenTelemetry.registerTracerProvider(
            tracerProvider: OTelTracerProvider()
        )

        let tracer = OpenTelemetry
            .instance
            .tracerProvider
            .get(instrumentationName: "", instrumentationVersion: nil)

        URLSessionInstrumentation.enableDurationBreakdown(
            with: .init(
                delegateClass: DistributedTraceDelegate.self
            )
        )

        let delegate = DistributedTraceDelegate()
        let urlSession = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)

        return OpenTelemetryTraceViewController(tracer: tracer, urlSession: urlSession)
    }
}
