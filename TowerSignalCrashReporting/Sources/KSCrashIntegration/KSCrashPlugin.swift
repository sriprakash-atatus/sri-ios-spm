/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; renamed
// `dd*` types to `TowerSignal*`; renamed the `DD` symbol prefix to `AT`; renamed `com.ddhq.*`
// identifiers to `com.towersignal.*`; rebranded the `dd` name to `TowerSignal` in comments and docs; rebranded
// the licence header.

import Foundation
import TowerSignalInternal

// swiftlint:disable duplicate_imports
#if COCOAPODS
import KSCrash
#elseif swift(>=6.0)
internal import KSCrashRecording
internal import KSCrashFilters
#else
@_implementationOnly import KSCrashRecording
@_implementationOnly import KSCrashFilters
#endif
// swiftlint:enable duplicate_imports

/// The implementation of `CrashReportingPlugin`.
/// Pass its instance as the crash reporting plugin for TowerSignal SDK to enable crash reporting feature.
@objc
internal class KSCrashPlugin: NSObject, CrashReportingPlugin {
    private let store: CrashReportStore
    private let telemetry: Telemetry

    init(_ kscrash: KSCrash = .shared, telemetry: Telemetry = NOPTelemetry()) throws {
        do {
            try kscrash.install(with: .towersignal())
            kscrash.reportStore?.sink = CrashReportFilterPipeline(
                filters: [
                    TowerSignalTypeSafeFilter(),
                    TowerSignalMinifyFilter(),
                    TowerSignalDiagnosticFilter(),
                    TowerSignalCrashReportFilter(telemetry: telemetry)
                ]
            )
        } catch KSCrashInstallError.alreadyInstalled {
            consolePrint("TowerSignalCrashReporting error: crash reporting is already installed", .warn)
            telemetry.debug("[KSCrash] already installed")
        } catch {
            telemetry.error("[KSCrash] Fails installation", error: error)
            throw error
        }

        guard let store = kscrash.reportStore else {
            throw CrashReportException(description: "[KSCrash] Report store should exist after installation")
        }

        self.telemetry = telemetry
        self.store = store
        super.init()
    }

    // MARK: - CrashReportingPlugin

    func readPendingCrashReport(completion: @escaping (ATCrashReport?) -> Bool) {
        self.store.sendAllReports { reports, error in
            do {
                if let error {
                    throw error
                }

                guard let report = reports?.first else {
                    _ = completion(nil)
                    return
                }

                guard let report = report.untypedValue as? ATCrashReport else {
                    throw CrashReportException(description: "Report is not of type ATCrashReport")
                }

                if completion(report) {
                    self.store.deleteAllReports()
                }
            } catch {
                _ = completion(nil)
                self.store.deleteAllReports()
                consolePrint("🔥 TowerSignalCrashReporting error: failed to load crash report: \(error)", .error)
                self.telemetry.error("[KSCrash] Fails to load crash report", error: error)
            }
        }
    }

    func inject(context: Data) {
        let contextString = String(decoding: context, as: UTF8.self)
        contextString.withCString {
            kscrash_setUserInfoJSON($0)
        }
    }

    var backtraceReporter: BacktraceReporting? { KSCrashBacktrace(telemetry: telemetry) }
}

extension KSCrashConfiguration {
    static func towersignal() throws -> KSCrashConfiguration {
        let version = "v2"

        guard let cache = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            throw CrashReportException(description: "Cannot obtain `/Library/Caches/` url.")
        }

        let directory = cache.appendingPathComponent("com.towersignal.crash-reporting/\(version)", isDirectory: true)

        let config = KSCrashConfiguration()
        config.installPath = directory.path
        // Disable `.mackException` monitor. The choice of `.BSD` (.signal) over `.mach` is well discussed here:
        // https://github.com/microsoft/PLCrashReporter/blob/7f27b272d5ff0d6650fc41317127bb2378ed6e88/Source/CrashReporter.h#L238-L363
        config.monitors = [.signal, .cppException, .nsException, .system]
        config.reportStoreConfiguration.maxReportCount = 1
        config.reportStoreConfiguration.reportCleanupPolicy = .never
        // Disable swapping the `__cxa_throw` function as it can cause process termination
        // in some setups when C++ exceptions are thrown.
        // See https://github.com/dd/towersignal-sdk-ios/issues/2659
        config.enableSwapCxaThrow = false
        return config
    }
}
