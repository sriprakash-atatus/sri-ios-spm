/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; rebranded the
// licence header.

import Foundation
import TowerSignalInternal

extension Event: AnyMockable {
    public static func mockAny() -> Self {
        return mockWith()
    }

    public static func mockWith(data: Data = .init(), metadata: Data? = nil) -> Self {
        return Event(data: data, metadata: metadata)
    }
}
