/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; rebranded the
// licence header.

#if os(iOS)
import Foundation
import TowerSignalInternal

/// Controls when observed layer callbacks become screen changes.
internal final class ScreenChangeFilter {
    private var ignoredScopesCount = 0

    var acceptsChanges: Bool {
        dd_assert(Thread.isMainThread, "ScreenChangeFilter must be used from the main thread")
        return ignoredScopesCount == 0
    }

    func ignoringChanges<T>(_ operation: () throws -> T) rethrows -> T {
        dd_assert(Thread.isMainThread, "ScreenChangeFilter must be used from the main thread")

        ignoredScopesCount += 1
        defer {
            ignoredScopesCount -= 1
        }

        return try operation()
    }
}
#endif
