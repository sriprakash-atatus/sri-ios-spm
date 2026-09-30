/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddSessionReplay` -> `TowerSignalSessionReplay`;
// rebranded the licence header.

#if os(iOS)

import Foundation

@_spi(Internal)
@testable import TowerSignalSessionReplay

extension SessionReplay.Configuration.FeatureFlags {
    public static var allEnabled: Self {
        var flags: Self = [
            .swiftui: true,
            .heatmaps: true,
        ]

        if #available(iOS 13.0, tvOS 13.0, *) {
            flags[.compositionTreeRecording] = true
        }

        return flags
    }
}

#endif
