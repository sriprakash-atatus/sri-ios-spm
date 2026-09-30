/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddSessionReplay` -> `TowerSignalSessionReplay`;
// rebranded the licence header.

@testable import TowerSignalSessionReplay

class ResourceWriterMock: ResourcesWriting {
    var resources: [[EnrichedResource]] = []

    func write(resources: [EnrichedResource]) {
        self.resources.append(resources)
    }
}
