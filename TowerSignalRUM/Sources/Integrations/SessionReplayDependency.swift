/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; renamed
// `dd*` types to `TowerSignal*`; rebranded the licence header.

import Foundation
import TowerSignalInternal

// MARK: - Extracting SR context from `TowerSignalContext`

extension TowerSignalContext {
    /// The Session Replay configuration.
    var sessionReplayConfiguration: SessionReplayCoreContext.Configuration? {
        additionalContext(ofType: SessionReplayCoreContext.Configuration.self)
    }

    /// The value indicating if replay is being performed by Session Replay.
    var hasReplay: Bool? {
        additionalContext(ofType: SessionReplayCoreContext.HasReplay.self)?.value
    }

    /// The value of `[String: Int64]` that indicates number of records recorded for a given viewID.
    var recordsCountByViewID: [String: Int64] {
        additionalContext(ofType: SessionReplayCoreContext.RecordsCount.self)?.value ?? [:]
    }
}
