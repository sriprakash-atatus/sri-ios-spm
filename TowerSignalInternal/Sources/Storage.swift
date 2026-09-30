/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed `dd*` types to `TowerSignal*`; rebranded the `dd` name to
// `TowerSignal` in comments and docs; rebranded the licence header.

import Foundation

/// A TowerSignal  protocol that provides persistence related information.
public protocol Storage {
    /// Returns the most recent modified file before a given date.
    /// - Parameter before: The date to compare the last modification date of files.
    /// - Returns: The most recent modified file or `nil` if no files were modified before the given date.
    func mostRecentModifiedFileAt(before: Date) throws -> Date?
}

internal struct CoreStorage: Storage {
    /// A weak core reference.
    private weak var core: TowerSignalCoreProtocol?

    /// Creates a Storage associated with a core instance.
    ///
    /// The `CoreStorage` keeps a weak reference
    /// to the provided core.
    ///
    /// - Parameter core: The core instance.
    init(core: TowerSignalCoreProtocol) {
        self.core = core
    }

    /// Returns the most recent modified file before a given date from the core.
    /// - Parameter before: The date to compare the last modification date of files.
    /// - Returns: The most recent modified file or `nil` if no files were modified before the given date.
    func mostRecentModifiedFileAt(before: Date) throws -> Date? {
        try core?.mostRecentModifiedFileAt(before: before)
    }
}
