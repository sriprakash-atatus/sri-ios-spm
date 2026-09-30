/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddSessionReplay` -> `TowerSignalSessionReplay`;
// rebranded the licence header.

#if os(iOS)
import QuartzCore

@testable import TowerSignalSessionReplay

final class CALayerObserverMock: CALayerObserver {
    var layerDidDisplayCalls: [CALayer] = []
    var layerDidDrawCalls: [(layer: CALayer, context: CGContext)] = []
    var layerDidLayoutSublayersCalls: [CALayer] = []

    func layerDidDisplay(_ layer: CALayer) {
        layerDidDisplayCalls.append(layer)
    }

    func layerDidDraw(_ layer: CALayer, in context: CGContext) {
        layerDidDrawCalls.append((layer, context))
    }

    func layerDidLayoutSublayers(_ layer: CALayer) {
        layerDidLayoutSublayersCalls.append(layer)
    }
}
#endif
