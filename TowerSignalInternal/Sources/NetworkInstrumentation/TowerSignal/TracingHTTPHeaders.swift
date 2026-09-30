/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed the `_dd` attribute prefix to `_towersignal`; renamed the `x-dd-*`
// trace headers to `x-towersignal-*`; repointed the intake host at the TowerSignal site; rebranded the `dd` name
// to `TowerSignal` in comments and docs; rebranded the licence header.

import Foundation

/// Trace propagation headers as explained in
/// https://www.towersignal.com/docs/
public enum TracingHTTPHeaders {
    /// Trace propagation header.
    /// It is used both in Tracing and RUM features.
    public static let traceIDField = "x-towersignal-trace-id"

    /// Trace propagation header.
    /// In RUM - it allows TowerSignal to generate the first span from the trace.
    /// In Tracing - it injects the `spanID` of mobile span so downstream spans can be properly linked in distributed tracing.
    public static let parentSpanIDField = "x-towersignal-parent-id"

    /// To make sure that the Agent keeps the trace.
    /// It is used both in Tracing and RUM features.
    public static let samplingPriorityField = "x-towersignal-sampling-priority"

    /// The TowerSignal origin of the Trace.
    ///
    /// Setting the value to 'rum' will indicate that the span is reported as a RUM Resource.
    public static let originField = "x-towersignal-origin"

    /// The TowerSignal tags of the Trace.
    public static let tagsField = "x-towersignal-tags"

    /// Keys for TowerSignal tags.
    public enum TagKeys {
        /// The TowerSignal tag key for the higher order 64 bits of the trace ID.
        public static let traceIDHi = "_towersignal.p.tid"
    }
}
