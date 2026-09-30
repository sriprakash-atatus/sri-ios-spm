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
import OpenTelemetrySdk

internal final class Meter: TowerSignalInternal.BenchmarkMeter {
    let meter: MeterSdk

    init(provider: MeterProviderSdk) {
        self.meter = provider.get(name: "benchmarks")
    }

    func counter(metric: @autoclosure () -> String) -> TowerSignalInternal.BenchmarkCounter {
        DoubleCounterWrapper(counter: meter.counterBuilder(name: metric()).ofDoubles().build())
    }

    func gauge(metric: @autoclosure () -> String) -> TowerSignalInternal.BenchmarkGauge {
        DoubleGaugeWrapper(gauge: meter.gaugeBuilder(name: metric()).build())
    }

    func observe(metric: @autoclosure () -> String, callback: @escaping (any TowerSignalInternal.BenchmarkGauge) -> Void) {
        _ = meter.gaugeBuilder(name: metric()).buildWithCallback { callback(ObservableDoubleMeasurementWrapper(measurement: $0)) }
    }
}

private final class DoubleCounterWrapper: TowerSignalInternal.BenchmarkCounter {
    var counter: DoubleCounterSdk

    init(counter: DoubleCounterSdk) {
        self.counter = counter
    }

    func add(value: Double, attributes: @autoclosure () -> [String: String]) {
        counter.add(value: value, attributes: attributes().mapValues { AttributeValue.string($0) })
    }
}

private final class DoubleGaugeWrapper: TowerSignalInternal.BenchmarkGauge {
    let gauge: DoubleGaugeSdk

    init(gauge: DoubleGaugeSdk) {
        self.gauge = gauge
    }

    func record(value: Double, attributes: @autoclosure () -> [String: String]) {
        gauge.record(value: value, attributes: attributes().mapValues { AttributeValue.string($0) })
    }
}

private struct ObservableDoubleMeasurementWrapper: TowerSignalInternal.BenchmarkGauge {
    let measurement: ObservableMeasurementSdk

    func record(value: Double, attributes: @autoclosure () -> [String: String]) {
        measurement.record(value: value, attributes: attributes().mapValues { AttributeValue.string($0) })
    }
}
