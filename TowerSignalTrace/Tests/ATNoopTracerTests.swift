/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`,
// `ddTrace` -> `TowerSignalTrace`; renamed `dd*` types to `TowerSignal*`; renamed the `DD` symbol prefix to
// `AT`; repointed the intake host at the TowerSignal site; rebranded the licence header.

import XCTest
import TestUtilities
import TowerSignalInternal

@testable import TowerSignalTrace

class ATNoopTracerTests: XCTestCase {
    func testWhenUsingDDNoopTracerAPIs_itPrintsWarning() {
        let dd = AT.mockWith(logger: CoreLoggerMock())
        defer { dd.reset() }

        // Given
        let noop = ATNoopTracer()

        // When
        let context = ATSpanContext.mockAny()
        noop.inject(
            spanContext: context,
            writer: HTTPHeadersWriter(traceContextInjection: .sampled)
        )
        _ = noop.extract(reader: HTTPHeadersReader(httpHeaderFields: [:]))
        let root = noop.startRootSpan(operationName: "root operation").setActive()
        let child = noop.startSpan(operationName: "child operation")
        child.finish()
        root.finish()

        // Then
        let expectedWarningMessage = """
        The `TowerSignalTracer.shared()` was called but `TowerSignalTracer` is not initialised. Configure the `TowerSignalTracer` before invoking the feature:
            TowerSignalTracer.initialize()
        See https://www.towersignal.com/docs/
        """

        XCTAssertEqual(dd.logger.warnLogs.count, 4)
        dd.logger.warnLogs.forEach { log in
            XCTAssertEqual(log.message, expectedWarningMessage)
        }
    }
}
