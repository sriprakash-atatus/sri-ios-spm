/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddBenchmarks` -> `TowerSignalBenchmarks`,
// `ddInternal` -> `TowerSignalInternal`; rebranded the licence header.

import Foundation
import TowerSignalInternal
import TowerSignalBenchmarks
import OpenTelemetryApi

internal final class Profiler: TowerSignalInternal.BenchmarkProfiler {
    let provider: TracerProvider

    init(provider: TracerProvider) {
        self.provider = provider
    }

    func tracer(operation: @autoclosure () -> String) -> any TowerSignalInternal.BenchmarkTracer {
        TracerWrapper(
            tracer: provider.get(
                instrumentationName: operation(),
                instrumentationVersion: nil
            )
        )
    }
}

private final class TracerWrapper: TowerSignalInternal.BenchmarkTracer {
    let tracer: OpenTelemetryApi.Tracer

    init(tracer: OpenTelemetryApi.Tracer) {
        self.tracer = tracer
    }

    func startSpan(named: @autoclosure () -> String) -> any TowerSignalInternal.BenchmarkSpan {
        SpanWrapper(
            span: tracer
                .spanBuilder(spanName: named())
                .setActive(true)
                .startSpan()
        )
    }
}

private final class SpanWrapper: TowerSignalInternal.BenchmarkSpan {
    let span: OpenTelemetryApi.Span

    init(span: OpenTelemetryApi.Span) {
        self.span = span
    }

    func stop() {
        span.end()
    }
}
