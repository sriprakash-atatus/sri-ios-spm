/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; rebranded the
// licence header.

import TowerSignalInternal

extension AccountConfigurationContext: AnyMockable, RandomMockable {
    public static func mockAny() -> Self { mockWith() }

    public static func mockRandom() -> Self {
        .init(
            id: .mockRandom(),
            name: .mockRandom()
        )
    }

    public static func mockWith(
        id: String = .mockAny(),
        name: String? = .mockAny()
    ) -> Self {
        .init(
            id: id,
            name: name
        )
    }
}
