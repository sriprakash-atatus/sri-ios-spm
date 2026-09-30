/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed the `DD` symbol prefix to `AT`; renamed the `x-dd-*` trace
// headers to `x-towersignal-*`; repointed the intake host at the TowerSignal site; rebranded the `dd` name to
// `TowerSignal` in comments and docs; rebranded the licence header.

import Foundation

/// The type of the tracing header injected to requests.
@objc(ATTracingHeaderType)
@objcMembers
@_spi(objc)
public final class objc_TracingHeaderType: NSObject {
    public let swiftType: TracingHeaderType

    private init(_ swiftType: TracingHeaderType) {
        self.swiftType = swiftType
    }

    /// [TowerSignal's `x-towersignal-*` header](https://www.towersignal.com/docs/).
    public static let towersignal = objc_TracingHeaderType(.towersignal)
    /// Open Telemetry B3 [Multiple headers](https://github.com/openzipkin/b3-propagation#multiple-headers).
    public static let b3multi = objc_TracingHeaderType(.b3multi)
    /// Open Telemetry B3 [Single header](https://github.com/openzipkin/b3-propagation#single-headers).
    public static let b3 = objc_TracingHeaderType(.b3)
    /// W3C [Trace Context header](https://www.w3.org/TR/trace-context/#tracestate-header)
    public static let tracecontext = objc_TracingHeaderType(.tracecontext)
}
