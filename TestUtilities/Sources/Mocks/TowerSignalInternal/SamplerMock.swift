/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; rebranded the
// licence header.

import Foundation
import TowerSignalInternal

extension Sampler: AnyMockable, RandomMockable {
    public static func mockAny() -> Sampler {
        return .init(samplingRate: 50)
    }

    public static func mockRandom() -> Sampler {
        return .init(samplingRate: .random(in: (0.0...100.0)))
    }

    public static func mockKeepAll() -> Sampler {
        return .init(samplingRate: 100)
    }

    public static func mockRejectAll() -> Sampler {
        return .init(samplingRate: 0)
    }
}

extension DeterministicSampler {
    /// Returns a sampler that always samples (100% rate, seed=0).
    public static func mockKeepAll() -> DeterministicSampler {
        return .init(seed: 0, samplingRate: 100)
    }

    /// Returns a sampler that never samples (0% rate, seed=0).
    public static func mockRejectAll() -> DeterministicSampler {
        return .init(seed: 0, samplingRate: 0)
    }
}
