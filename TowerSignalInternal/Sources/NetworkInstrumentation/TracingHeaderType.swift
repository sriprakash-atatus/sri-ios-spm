/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed the `x-dd-*` trace headers to `x-towersignal-*`; repointed the
// intake host at the TowerSignal site; rebranded the `dd` name to `TowerSignal` in comments and docs; rebranded
// the licence header.

import Foundation

/// The type of the tracing header injected to requests.
///
/// - `towersignal` - [TowerSignal's `x-towersignal-*` header](https://www.towersignal.com/docs/).
/// - `b3` - Open Telemetry B3 [Single header](https://github.com/openzipkin/b3-propagation#single-headers).
/// - `b3multi` - Open Telemetry B3 [Multiple headers](https://github.com/openzipkin/b3-propagation#multiple-headers).
/// - `tracecontext` - W3C [Trace Context header](https://www.w3.org/TR/trace-context/#tracestate-header)
@frozen
public enum TracingHeaderType: Hashable, Sendable {
    case towersignal
    case b3
    case b3multi
    case tracecontext
}
