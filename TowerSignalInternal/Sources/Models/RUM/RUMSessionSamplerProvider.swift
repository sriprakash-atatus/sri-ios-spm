/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed `dd*` types to `TowerSignal*`; rebranded the licence header.

import Foundation

/// Provides the RUM session deterministic sampler for the active session.
public protocol RUMSessionSamplerProvider {
    /// The RUM session deterministic sampler for the active session. `nil` if there is no active session.
    var rumSessionSampler: DeterministicSampler? { get }
}

public extension TowerSignalFeature where Self: RUMSessionSamplerProvider { }
