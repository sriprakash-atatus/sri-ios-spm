/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; rebranded the
// `dd` name to `TowerSignal` in comments and docs; rebranded the licence header.

import Foundation
import TowerSignalInternal

// MARK: - Global Dependencies Mocks

/// Mock which can be used to intercept messages printed by `developerLogger` or
/// `userLogger` by overwriting `TowerSignal.consolePrint` function:
///
///     let printFunction = PrintFunctionMock()
///     consolePrint = printFunction.print
///
public class PrintFunctionSpy: @unchecked Sendable {
    @ReadWriteLock
    public private(set) var printedMessages: [String] = []

    public var printedMessage: String? { printedMessages.last }

    public init() { }

    @Sendable
    public func print(message: String, level: CoreLoggerLevel) {
        printedMessages.append(message)
    }

    public func reset() {
        printedMessages = []
    }
}
