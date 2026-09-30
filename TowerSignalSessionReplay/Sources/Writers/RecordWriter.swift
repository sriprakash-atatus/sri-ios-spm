/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; renamed
// `dd*` types to `TowerSignal*`; rebranded the licence header.

#if os(iOS)
import Foundation
import TowerSignalInternal

/// A type writing Session Replay records to `TowerSignalCore`.
internal protocol RecordWriting {
    /// Writes next records to SDK core.
    func write(nextRecord: EnrichedRecord)
}

internal class RecordWriter: RecordWriting {
    /// An instance of SDK core the SR feature is registered to.
    private weak var core: TowerSignalCoreProtocol?

    init(core: TowerSignalCoreProtocol) {
        self.core = core
    }

    // MARK: - Writing

    func write(nextRecord: EnrichedRecord) {
        core?.scope(for: SessionReplayFeature.self).eventWriteContext { _, recordWriter in
            recordWriter.write(value: nextRecord)
        }
    }
}
#endif
