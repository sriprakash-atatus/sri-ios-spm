/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`, `ddLogs`
// -> `TowerSignalLogs`, `ddRUM` -> `TowerSignalRUM`, `ddTrace` -> `TowerSignalTrace`; renamed `dd*` types
// to `TowerSignal*`; rebranded the licence header.

import Foundation

@testable import TowerSignalLogs
@testable import TowerSignalRUM
@testable import TowerSignalTrace
@testable import TowerSignalInternal

extension TowerSignalCoreProxy {
    public func waitAndReturnSpanMatchers(file: StaticString = #file, line: UInt = #line) throws -> [SpanMatcher] {
        return try waitAndReturnEventsData(ofFeature: TraceFeature.name)
            .map { eventData in try SpanMatcher.fromJSONObjectData(eventData) }
    }

    public func waitAndReturnSpanEvents(file: StaticString = #file, line: UInt = #line) -> [SpanEvent] {
        return waitAndReturnEvents(ofFeature: TraceFeature.name, ofType: SpanEventsEnvelope.self)
            .map { envelope in
                precondition(envelope.spans.count == 1, "Only expect one `SpanEvent` per envelope")
                return envelope.spans[0]
            }
    }
}

extension TowerSignalCoreProxy {
    public func waitAndReturnLogMatchers(file: StaticString = #file, line: UInt = #line) throws -> [LogMatcher] {
        return try waitAndReturnEventsData(ofFeature: LogsFeature.name)
            .map { data in try LogMatcher.fromJSONObjectData(data) }
    }
}

extension TowerSignalCoreProxy {
    public func waitAndReturnRUMEventMatchers(file: StaticString = #file, line: UInt = #line) throws -> [RUMEventMatcher] {
        return try waitAndReturnEventsData(ofFeature: RUMFeature.name)
            .map { data in try RUMEventMatcher.fromJSONObjectData(data) }
    }
}
