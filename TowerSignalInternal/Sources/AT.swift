/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed `dd*` types to `TowerSignal*`; renamed the `DD` symbol prefix to
// `AT`; rebranded the `dd` name to `TowerSignal` in comments and docs; rebranded the licence header.

import Foundation

/// Core utilities for monitoring performance and execution of the SDK.
///
/// These are meant to be shared by all instances of the SDK and `TowerSignalCore`.
/// `AT` bundles static dependencies that must be available and functional right away,
/// so it is possible to monitor any phase of the SDK execution, including its initialization sequence.
public struct AT {
    /// The logger providing methods to print debug information and execution errors from TowerSignal SDK to user console.
    ///
    /// It is meant for debugging purposes when using the SDK, hence **it should log information useful and actionable
    /// to the SDK user**. Think of possible logs that we may want to receive from our users when asking them to enable
    /// SDK verbosity and send us their console log.
    ///
    /// The lock prevents race conditions when the logger is replaced
    /// during SDK initialization while being accessed from other threads.
    @ReadWriteLock
    public static var logger: CoreLogger = InternalLogger(
        dateProvider: SystemDateProvider(),
        timeZone: .current,
        printFunction: consolePrint,
        verbosityLevel: { .debug }
    )
}

#if canImport(OSLog)
import OSLog
#endif

// TODO: RUM-14097 consolePrint needs to handle concurrency in a better way
// to support concurrency without `nonisolated(unsafe)` and tests running in parallel.
/// Function printing `String` content to console.
nonisolated(unsafe) public var consolePrint: @Sendable (String, CoreLoggerLevel) -> Void = { message, level in
    #if canImport(OSLog)
    if #available(iOS 14.0, tvOS 14.0, *) {
        switch level {
        case .debug: Logger.towersignal.debug("\(message, privacy: .private)")
        case .warn: Logger.towersignal.warning("\(message, privacy: .private)")
        case .error: Logger.towersignal.critical("\(message, privacy: .private)")
        case .critical: Logger.towersignal.fault("\(message, privacy: .private)")
        }
    } else {
        print(message)
    }
    #else
    print(message)
    #endif
}

#if canImport(OSLog)
@available(iOS 14.0, tvOS 14.0, *)
extension Logger {
    static let towersignal = Logger(subsystem: "towersignal-sdk-ios", category: "TowerSignalInternal")
}
#endif
