/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; renamed
// `dd*` types to `TowerSignal*`; rebranded the licence header.

import Foundation
import TowerSignalInternal

internal final class TraceFeature: TowerSignalRemoteFeature {
    static let name = "tracing"

    let requestBuilder: FeatureRequestBuilder
    var messageReceiver: FeatureMessageReceiver { contextReceiver }

    let tracer: TowerSignalTracer
    let contextReceiver: ContextMessageReceiver

    /// Allows overriding certain performance presets if needed. Default is nil.
    let performanceOverride: PerformancePresetOverride?

    init(
        in core: TowerSignalCoreProtocol,
        configuration: Trace.Configuration
    ) {
        self.requestBuilder = TracingRequestBuilder(
            customIntakeURL: configuration.customEndpoint,
            telemetry: core.telemetry
        )

        let sampleRate = configuration.debugSDK ? 100 : configuration.sampleRate
        let samplingProvider = SamplerProvider(sampleRate: sampleRate)

        self.contextReceiver = ContextMessageReceiver(samplerProvider: samplingProvider)
        self.tracer = TowerSignalTracer(
            core: core,
            samplingProvider: samplingProvider,
            tags: configuration.tags ?? [:],
            traceIDGenerator: configuration.traceIDGenerator,
            spanIDGenerator: configuration.spanIDGenerator,
            dateProvider: configuration.dateProvider,
            loggingIntegration: TracingWithLoggingIntegration(
                core: core,
                service: configuration.service,
                networkInfoEnabled: configuration.networkInfoEnabled
            ),
            spanEventBuilder: SpanEventBuilder(
                service: configuration.service,
                networkInfoEnabled: configuration.networkInfoEnabled,
                eventsMapper: configuration.eventMapper,
                bundleWithRUM: configuration.bundleWithRumEnabled,
                telemetry: core.telemetry
            )
        )
        self.performanceOverride = nil

        // Send configuration telemetry:
        core.telemetry.configuration(useTracing: true)
    }
}
