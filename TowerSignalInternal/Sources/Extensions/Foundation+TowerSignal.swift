/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed `dd*` types to `TowerSignal*`; rebranded the licence header.

import Foundation

extension Thread: TowerSignalExtended {}
extension TowerSignalExtension where ExtendedType: Thread {
    /// Returns the name of current thread if available or the nature of thread otherwise: `"main" | "background"`.
    public var name: String {
        if let name = Thread.current.name, !name.isEmpty {
            return name
        }

        return Thread.isMainThread ? "main" : "background"
    }
}
