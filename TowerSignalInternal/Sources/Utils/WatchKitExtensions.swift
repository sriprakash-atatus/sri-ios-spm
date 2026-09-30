/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed `dd*` types to `TowerSignal*`; rebranded the licence header.

import Foundation

#if canImport(WatchKit)
import WatchKit

extension TowerSignalExtension where ExtendedType == WKExtension {
    public static var shared: WKExtension {
        .shared()
    }
}

extension WKExtension: TowerSignalExtended { }
#endif
