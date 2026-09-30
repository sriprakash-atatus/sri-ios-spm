/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; rebranded the
// licence header.

import Foundation
import TowerSignalInternal

public struct HeatmapIdentifierRegistryMock: @unchecked Sendable, HeatmapIdentifierRegistry {
    @ReadWriteLock
    public var identifiers: [ObjectIdentifier: HeatmapIdentifier]

    public init(identifiers: [ObjectIdentifier: HeatmapIdentifier] = [:]) {
        self.identifiers = identifiers
    }

    public func setHeatmapIdentifiers(_ heatmapIdentifiers: [ObjectIdentifier: HeatmapIdentifier]) {
        identifiers = heatmapIdentifiers
    }

    public func heatmapIdentifier(for objectIdentifier: ObjectIdentifier) -> HeatmapIdentifier? {
        identifiers[objectIdentifier]
    }
}
