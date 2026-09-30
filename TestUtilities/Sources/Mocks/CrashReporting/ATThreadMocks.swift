/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; renamed the
// `DD` symbol prefix to `AT`; rebranded the licence header.

import TowerSignalInternal

extension ATThread: AnyMockable, RandomMockable {
    public static func mockAny() -> ATThread {
        return .mockWith()
    }

    public static func mockRandom() -> ATThread {
        return ATThread(
            name: .mockRandom(),
            stack: .mockRandom(),
            crashed: .mockRandom(),
            state: .mockRandom()
        )
    }

    public static func mockWith(
        name: String = .mockAny(),
        stack: String = .mockAny(),
        crashed: Bool = .mockAny(),
        state: String? = .mockAny()
    ) -> ATThread {
        return ATThread(
            name: name,
            stack: stack,
            crashed: crashed,
            state: state
        )
    }
}
