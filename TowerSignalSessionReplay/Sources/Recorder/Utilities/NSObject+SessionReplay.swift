/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; rebranded the
// licence header.

#if os(iOS)

import Foundation
@preconcurrency import TowerSignalInternal

extension NSObject {
    func safeValue(forKey key: String) -> Any? {
        try? objc_rethrow {
            value(forKey: key)
        }
    }
}
#endif
