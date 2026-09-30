/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed `dd*` types to `TowerSignal*`; rebranded the licence header.

import Foundation

internal final class HeatmapIdentifierRegistryFeature: TowerSignalFeature {
    static var name: String = "heatmap-identifier-registry"

    let messageReceiver: FeatureMessageReceiver = NOPFeatureMessageReceiver()
    let registry: HeatmapIdentifierRegistry

    init(registry: HeatmapIdentifierRegistry) {
        self.registry = registry
    }
}
