/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddSessionReplay` -> `TowerSignalSessionReplay`;
// rebranded the licence header.

#if os(iOS)
import Foundation
@testable import TowerSignalSessionReplay

/// Spies the interaction with `Processing`.
public class SnapshotProcessorSpy: SnapshotProcessing {
    /// An array of snapshots recorded in `process(viewTreeSnapshot:touchSnapshot:)`
    public private(set) var processedSnapshots: [(viewTreeSnapshot: ViewTreeSnapshot, touchSnapshot: TouchSnapshot?)] = []

    public init() {}

    public func process(viewTreeSnapshot: ViewTreeSnapshot, touchSnapshot: TouchSnapshot?) {
        processedSnapshots.append((viewTreeSnapshot, touchSnapshot))
    }
}
#endif
