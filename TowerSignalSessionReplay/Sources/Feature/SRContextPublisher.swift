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

/// Publisher that sets Session Replay context for being utilized by other Features.
internal class SRContextPublisher {
    private weak var core: TowerSignalCoreProtocol?
    private var recordCounts: [String: Int64] = [:]

    init(core: TowerSignalCoreProtocol) {
        self.core = core
    }

    /// Notifies other Features if Session Replay is recording.
    func setHasReplay(_ value: Bool) {
        core?.set(context: SessionReplayCoreContext.HasReplay(value: value))
    }

    /// Increments the Session Replay record count for a RUM view.
    func incrementRecordCount(by count: Int64, forViewID viewID: String) {
        guard count > 0 else {
            return
        }

        core?.set(
            context: {
                self.recordCounts[viewID, default: 0] += count
                return SessionReplayCoreContext.RecordsCount(value: self.recordCounts)
            }
        )
    }
}
#endif
