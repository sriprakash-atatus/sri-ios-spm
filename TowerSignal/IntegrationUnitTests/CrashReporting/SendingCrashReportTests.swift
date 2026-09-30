/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddCrashReporting` -> `TowerSignalCrashReporting`,
// `ddInternal` -> `TowerSignalInternal`, `ddLogs` -> `TowerSignalLogs`, `ddRUM` -> `TowerSignalRUM`;
// renamed `dd*` types to `TowerSignal*`; renamed the `DD` symbol prefix to `AT`; rebranded the licence
// header.

import XCTest
import TestUtilities
@testable import TowerSignalCrashReporting
import TowerSignalInternal
@testable import TowerSignalLogs
@testable import TowerSignalRUM

/// A crash reporter mock with two capabilities:
/// - notifying a pending crash report found at SDK init,
/// - recording crash context data injected from SDK core and features like RUM.
private class CrashReporterMock: CrashReportingPlugin {
    @ReadWriteLock
    var pendingCrashReport: ATCrashReport?
    @ReadWriteLock
    var injectedContext: Data? = nil
    /// Custom backtrace reporter injected to the plugin.
    var injectedBacktraceReporter: BacktraceReporting?

    init(pendingCrashReport: ATCrashReport? = nil) {
        self.pendingCrashReport = pendingCrashReport
    }

    func readPendingCrashReport(completion: (ATCrashReport?) -> Bool) { _ = completion(pendingCrashReport) }
    func inject(context: Data) { injectedContext = context }
    var backtraceReporter: BacktraceReporting? { injectedBacktraceReporter }
}

/// Covers broad scenarios of sending Crash Reports.
class SendingCrashReportTests: XCTestCase {
    private var core: TowerSignalCoreProxy! // swiftlint:disable:this implicitly_unwrapped_optional

    override func setUp() {
        super.setUp()
        core = TowerSignalCoreProxy(context: .mockWith(trackingConsent: .granted))
    }

    override func tearDownWithError() throws {
        try core.flushAndTearDown()
        core = nil
        super.tearDown()
    }

    func testWhenSDKStartsWithPendingCrashReport_itSendsItAsRUMEvent() throws {
        // Given
        let crashContext: CrashContext = .mockWith(
            trackingConsent: .granted, // CR from the app session that has enabled data collection
            lastIsAppInForeground: true, // CR occurred while the app was in the foreground
            lastRUMAttributes: .mockRandom(),
            lastLogAttributes: .mockRandom()
        )
        let crashReport: ATCrashReport = .mockRandomWith(context: crashContext)
        let crashReportAttributes: [String: Encodable] = try XCTUnwrap(crashReport.additionalAttributes.dd.decode())

        // When
        RUM.enable(with: .init(applicationID: "rum-app-id"), in: core)
        CrashReporting.enable(with: CrashReporterMock(pendingCrashReport: crashReport), in: core)

        // Then (RUMError is sent)
        let rumEvent = try XCTUnwrap(core.waitAndReturnEvents(ofFeature: RUMFeature.name, ofType: RUMErrorEvent.self).first)
        XCTAssertEqual(rumEvent.error.message, crashReport.message)
        XCTAssertEqual(rumEvent.error.type, crashReport.type)
        XCTAssertEqual(rumEvent.error.stack, crashReport.stack)
        XCTAssertNotNil(rumEvent.error.threads)
        XCTAssertNotNil(rumEvent.error.binaryImages)
        XCTAssertNotNil(rumEvent.error.meta)
        XCTAssertNotNil(rumEvent.error.wasTruncated)
        let contextAttributes = try XCTUnwrap(rumEvent.context?.contextInfo)
        let lastRUMAttributes = try XCTUnwrap(crashContext.lastRUMAttributes?.contextInfo)
        ATAssertJSONEqual(contextAttributes, lastRUMAttributes.merging(crashReportAttributes) { $1 })
    }
}
