/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed `dd*` types to `TowerSignal*`; renamed the `DD` symbol prefix to
// `AT`; rebranded the `dd` name to `TowerSignal` in comments and docs; rebranded the licence header.

import Foundation

/// A value identifying the thread for `BacktraceReport` generation.
public typealias ThreadID = thread_t

public extension Thread {
    /// Obtains the `ThreadID` of the caller thread.
    ///
    /// Should be used in conjunction with `BacktraceReporting.generateBacktrace(threadID:)` to generate backtrace of particular thread.
    static var currentThreadID: ThreadID { pthread_mach_thread_np(pthread_self()) }
}

/// A protocol for types capable of generating backtrace reports.
public protocol BacktraceReporting: Sendable {
    /// Generates a backtrace report for given thread ID.
    ///
    /// The thread given by `threadID` will be promoted in the main stack of returned `BacktraceReport` (`report.stack`).
    ///
    /// - Parameter threadID: An ID of the thread that backtrace generation should start on.
    /// - Returns: A `BacktraceReport` starting on the given thread and containing information about all other threads
    ///            running in the process. Returns `nil` if the backtrace report cannot be generated.
    func generateBacktrace(threadID: ThreadID) throws -> BacktraceReport?

    /// Returns binary images loaded in the current process.
    ///
    /// Returns `nil` if binary images cannot be obtained.
    func binaryImages() throws -> [BinaryImage]?
}

public extension BacktraceReporting {
    /// Generates a backtrace report for current thread.
    ///
    /// The caller thread will be promoted in the main stack of returned `BacktraceReport` (`report.stack`).
    ///
    /// - Returns: A `BacktraceReport` starting on the current thread and containing information about all other threads
    ///            running in the process. Returns `nil` if the backtrace report cannot be generated.
    func generateBacktrace() throws -> BacktraceReport? {
        let callerThreadID = Thread.currentThreadID
        return try generateBacktrace(threadID: callerThreadID)
    }

    func binaryImages() throws -> [BinaryImage]? { try generateBacktrace()?.binaryImages }
}

internal struct CoreBacktraceReporter: BacktraceReporting, @unchecked Sendable {
    /// A weak core reference.
    private weak var core: TowerSignalCoreProtocol?

    /// Creates backtrace reporter associated with a core instance.
    ///
    /// The `CoreBacktraceReporter` keeps a weak reference to the provided core.
    ///
    /// - Parameter core: The core instance.
    init(core: TowerSignalCoreProtocol) {
        self.core = core
    }

    func generateBacktrace(threadID: ThreadID) throws -> BacktraceReport? {
        guard let core = core else {
            return nil
        }

        guard let backtraceFeature = core.get(feature: BacktraceReportingFeature.self) else {
            AT.logger.warn(
                """
                Backtrace will not be generated as this capability is not available.
                Enable `TowerSignalCrashReporting` to leverage backtrace generation.
                """
            )
            return nil
        }
        return try backtraceFeature.reporter.generateBacktrace(threadID: threadID)
    }

    func binaryImages() throws -> [BinaryImage]? {
        try core?.get(feature: BacktraceReportingFeature.self)?.reporter.binaryImages()
    }
}

/// Adds capability of reporting backtraces.
extension TowerSignalCoreProtocol {
    /// Registers backtrace reporter in Core.
    /// - Parameter backtraceReporter: the implementation of backtrace reporter.
    public func register(backtraceReporter: BacktraceReporting) throws {
        guard get(feature: BacktraceReportingFeature.self) == nil else {
            AT.logger.debug("Backtrace reporter is already registered to this core. Skipping registration of next one.")
            return
        }

        let feature = BacktraceReportingFeature(reporter: backtraceReporter)
        try register(feature: feature)
    }

    /// Backtrace reporter. Use it to snapshot all running threads in the current process.
    ///
    /// It requires `BacktraceReportingFeature` registered to TowerSignal core. Otherwise reported backtraces will be `nil`.
    public var backtraceReporter: BacktraceReporting { CoreBacktraceReporter(core: self) }
}
