/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - rebranded the licence header.

#if os(iOS)
import Foundation
import QuartzCore

/// Provides the current time used by recording components.
internal protocol TimeSource {
    var now: TimeInterval { get }
}

/// Time source backed by Core Animation's monotonic media time.
internal struct MediaTimeSource: TimeSource {
    var now: TimeInterval {
        CACurrentMediaTime()
    }
}
#endif
