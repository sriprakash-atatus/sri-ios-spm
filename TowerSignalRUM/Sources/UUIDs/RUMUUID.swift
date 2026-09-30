/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - rebranded the licence header.

import Foundation

internal struct RUMUUID: Equatable, Hashable {
    let rawValue: UUID

    /// UUID with all zeros, used to represent no-op values.
    static let nullUUID = RUMUUID(rawValue: .dd.nullUUID)
}

extension Optional where Wrapped == RUMUUID {
    var orNull: RUMUUID { self ?? RUMUUID.nullUUID }
}
