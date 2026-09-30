/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; renamed the
// `DD` symbol prefix to `AT`; rebranded the licence header.

import Foundation
import TowerSignalInternal

/// Defines whether the trace context should be injected into all requests or only sampled ones.
@objc(ATTraceContextInjection)
@_spi(objc)
public enum objc_TraceContextInjection: Int {
    internal var swiftType: TowerSignalInternal.TraceContextInjection {
        switch self {
        case .all:
            return .all
        case .sampled:
            return .sampled
        }
    }

    /// Injects trace context into all requests irrespective of the sampling decision.
    case all

    /// Injects trace context only into sampled requests.
    case sampled
}
