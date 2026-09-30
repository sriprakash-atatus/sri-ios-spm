/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; rebranded the
// licence header.

import Foundation
import TowerSignalInternal

extension Vital: AnyMockable, RandomMockable {
    public static func mockAny() -> Self {
        mockWith()
    }

    public static func mockRandom() -> Self {
        mockWith(
            id: .mockRandom(),
            name: .mockRandom(),
            operationKey: .mockRandom(),
            stepType: [.start, .end].randomElement()!,
            date: .mockRandom(),
            duration: .mockRandom()
        )
    }

    public static func mockWith(
        id: String = .mockAny(),
        name: String = .mockAny(),
        operationKey: String? = .mockAny(),
        stepType: RUMVitalOperationStepEvent.Vital.StepType? = .start,
        date: Date = .mockAny(),
        serverTimeOffset: TimeInterval = .zero,
        duration: Int64? = nil
    ) -> Self {
        .init(
            id: id,
            name: name,
            operationKey: operationKey,
            stepType: stepType,
            date: date,
            serverTimeOffset: serverTimeOffset,
            duration: duration
        )
    }
}
