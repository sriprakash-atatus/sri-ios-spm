/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; renamed the
// `DD` symbol prefix to `AT`; rebranded the licence header.

import Foundation
import TowerSignalInternal

extension ATError: AnyMockable, RandomMockable {
    public static func mockAny() -> ATError {
        return ATError(
            type: .mockAny(),
            message: .mockAny(),
            stack: .mockAny()
        )
    }

    public static func mockRandom() -> ATError {
        return ATError(
            type: .mockRandom(),
            message: .mockRandom(),
            stack: .mockRandom()
        )
    }
}
