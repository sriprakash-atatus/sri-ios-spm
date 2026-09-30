/*
* Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
* This product includes software developed at TowerSignal (https://www.towersignal.com/).
* Copyright 2026-Present TowerSignal, Inc.
*/

// ATCHG: TowerSignal SDK migration - renamed module imports `ddCore` -> `TowerSignalCore`,
// `ddCrashReporting` -> `TowerSignalCrashReporting`, `ddLogs` -> `TowerSignalLogs`, `ddTrace` ->
// `TowerSignalTrace`; renamed `dd*` types to `TowerSignal*`; renamed `clientToken` to `licenseKey`; rebranded
// the `dd` name to `TowerSignal` in comments and docs; rebranded the licence header.

import TowerSignalCore
import TowerSignalLogs
import TowerSignalTrace
import TowerSignalCrashReporting

@MainActor
enum TowerSignalSetup {
    static var logger: LoggerProtocol?
    static func initialize() {
        TowerSignal.initialize(
            with: TowerSignal.Configuration(licenseKey: "abc", env: "tests"),
            trackingConsent: .granted
        )

        Logs.enable()

        CrashReporting.enable()

        logger = Logger.create(
            with: Logger.Configuration(
                remoteSampleRate: 0,
                consoleLogFormat: .short
            )
        )

        // Trace APIs must be visible:
        Trace.enable()

        logger?.info("It works")
        let span = Tracer.shared().startSpan(operationName: "this too")
        span.finish()
    }
}
