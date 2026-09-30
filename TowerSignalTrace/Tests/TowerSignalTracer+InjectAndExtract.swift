/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`,
// `ddTrace` -> `TowerSignalTrace`; renamed `dd*` types to `TowerSignal*`; renamed the `DD` symbol prefix to
// `AT`; rebranded the licence header.

import XCTest
import TestUtilities
import TowerSignalInternal
@testable import TowerSignalTrace

private class MockWriter: OTFormatWriter, TracePropagationHeadersWriter {
    var traceHeaderFields: [String: String] = [:]
    var injectedTraceContext: TraceContext?
    func write(traceContext: TraceContext) { injectedTraceContext = traceContext }
}

private class MockReader: OTFormatReader, TracePropagationHeadersReader {
    var extractedIDs: (traceID: TraceID, spanID: SpanID, parentSpanID: SpanID?)? = nil
    var extractedSamplingPriority: SamplingPriority? = nil
    var extractedSamplingDecisionMaker: SamplingMechanismType? = nil

    func read() -> (traceID: TraceID, spanID: SpanID, parentSpanID: SpanID?)? { extractedIDs }
    var samplingPriority: TowerSignalInternal.SamplingPriority? { extractedSamplingPriority }
    var samplingDecisionMaker: TowerSignalInternal.SamplingMechanismType? { extractedSamplingDecisionMaker }
}

class TowerSignalTracer_InjectAndExtract: XCTestCase {
    private func createTracer(sampleRate: Float) -> TowerSignalTracer {
        return TowerSignalTracer(
            featureScope: NOPFeatureScope(),
            samplingProvider: TracerSamplerProviderMock(sampler: Sampler(samplingRate: sampleRate)),
            tags: [:],
            traceIDGenerator: DefaultTraceIDGenerator(),
            spanIDGenerator: DefaultSpanIDGenerator(),
            dateProvider: DateProviderMock(),
            loggingIntegration: .mockAny(),
            spanEventBuilder: .mockAny()
        )
    }

    func testInjectingSpanContextIntoWriter() {
        // Given
        let spanContext = ATSpanContext(
            traceID: .mockRandom(),
            spanID: .mockRandom(),
            parentSpanID: .mockRandom(),
            baggageItems: .mockAny(),
            sampleRate: .mockRandom(min: 0, max: 100),
            samplingDecision: .mockRandom()
        )

        let tracer = createTracer(sampleRate: 42)
        let writer = MockWriter()
        XCTAssertNil(writer.injectedTraceContext)

        // When
        tracer.inject(spanContext: spanContext, writer: writer)

        // Then
        let expectedTraceContext = TraceContext(
            traceID: spanContext.traceID,
            spanID: spanContext.spanID,
            parentSpanID: spanContext.parentSpanID,
            sampleRate: spanContext.sampleRate,
            samplingPriority: spanContext.samplingDecision.samplingPriority,
            samplingDecisionMaker: spanContext.samplingDecision.decisionMaker,
            rumSessionId: nil
        )
        XCTAssertEqual(writer.injectedTraceContext, expectedTraceContext)
    }

    func testExtractingSpanContextFromReader() throws {
        // Given
        let tracer = createTracer(sampleRate: 42)
        let reader = MockReader()
        let ids: (traceID: TraceID, spanID: SpanID, parentSpanID: SpanID?) = (.mockRandom(), .mockRandom(), .mockRandom())
        let samplingDecision: SamplingDecision = .mockRandom()
        reader.extractedIDs = ids
        reader.extractedSamplingPriority = samplingDecision.samplingPriority
        reader.extractedSamplingDecisionMaker = samplingDecision.decisionMaker

        // When
        let spanContext = try XCTUnwrap(tracer.extract(reader: reader) as? ATSpanContext)

        // Then
        XCTAssertEqual(spanContext.traceID, ids.traceID)
        XCTAssertEqual(spanContext.spanID, ids.spanID)
        XCTAssertEqual(spanContext.parentSpanID, ids.parentSpanID)
        XCTAssertEqual(spanContext.sampleRate, 42)
        XCTAssertEqual(spanContext.samplingDecision.samplingPriority, samplingDecision.samplingPriority)
        XCTAssertEqual(spanContext.samplingDecision.decisionMaker, samplingDecision.decisionMaker)
    }

    func testExtractsEmptySpanContextFromReader() throws {
        // Given
        let tracer = createTracer(sampleRate: 42)
        let reader = MockReader()
        reader.extractedIDs = nil
        reader.extractedSamplingPriority = nil
        reader.extractedSamplingDecisionMaker = nil

        // When
        XCTAssertNil(tracer.extract(reader: reader))
    }
}
