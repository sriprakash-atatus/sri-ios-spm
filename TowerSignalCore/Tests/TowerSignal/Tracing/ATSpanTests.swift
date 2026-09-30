/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`, `ddLogs`
// -> `TowerSignalLogs`, `ddTrace` -> `TowerSignalTrace`; renamed `dd*` types to `TowerSignal*`; renamed the `DD`
// symbol prefix to `AT`; rebranded the licence header.

import XCTest
import TestUtilities
import TowerSignalInternal

@testable import TowerSignalLogs
@testable import TowerSignalTrace

class ATSpanTests: XCTestCase {
    // MARK: - Sending Span Logs

    func testWhenLoggingSpanEvent_itWritesLogToLogOutput() throws {
        let core = TowerSignalCoreProxy()
        defer { XCTAssertNoThrow(try core.flushAndTearDown()) }

        Logs.enable(in: core)
        Trace.enable(in: core)

        // Given
        let tracer = Tracer.shared(in: core)
        let span = tracer.startSpan(operationName: .mockAny())

        // When
        let log1Fields = mockRandomAttributes()
        span.log(fields: log1Fields)

        let log2Fields = mockRandomAttributes()
        span.log(fields: log2Fields)

        // Then
        let logs: [LogEvent] = core.waitAndReturnEvents(ofFeature: LogsFeature.name, ofType: LogEvent.self)
        XCTAssertEqual(logs.count, 2, "It should send 2 logs")
        ATAssertJSONEqual(
            AnyEncodable(logs[0].attributes.userAttributes),
            AnyEncodable(log1Fields)
        )
        ATAssertJSONEqual(
            AnyEncodable(logs[1].attributes.userAttributes),
            AnyEncodable(log2Fields)
        )
    }
}
