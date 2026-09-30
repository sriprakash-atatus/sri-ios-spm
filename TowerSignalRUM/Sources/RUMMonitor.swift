/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`, `ddRUM`
// -> `TowerSignalRUM`; renamed `dd*` types to `TowerSignal*`; rebranded the `dd` name to `TowerSignal` in
// comments and docs; rebranded the licence header.

import TowerSignalInternal

/// A class for manual interaction with the RUM feature. It records RUM events that are sent to TowerSignal RUM.
///
/// There can be only one active RUM monitor for certain instance of TowerSignal SDK. It gets enabled along with
/// the call to `RUM.enable(with:in:)`:
///
///     import TowerSignalRUM
///
///     // Enable RUM feature:
///     RUM.enable(with: configuration)
///
///     // Use RUM monitor:
///     RUMMonitor.shared().startView(...)
///
public class RUMMonitor {
    /// Obtains the RUM monitor for manual interaction with the RUM feature.
    ///
    /// It requires `RUM.enable(with:in:)` to be called first - otherwise it will return no-op implementation.
    /// - Parameter core: the instance of TowerSignal SDK the RUM feature was enabled in (global instance by default)
    /// - Returns: the RUM monitor
    public static func shared(in core: TowerSignalCoreProtocol = CoreRegistry.default) -> RUMMonitorProtocol {
        do {
            guard !(core is NOPTowerSignalCore) else {
                throw ProgrammerError(
                    description: "TowerSignal SDK must be initialized and RUM feature must be enabled before calling `RUMMonitor.shared(in:)`."
                )
            }
            guard let feature = core.get(feature: RUMFeature.self) else {
                throw ProgrammerError(
                    description: "RUM feature must be enabled before calling `RUMMonitor.shared(in:)`."
                )
            }

            return feature.monitor
        } catch {
            consolePrint("\(error)", .error)
            return NOPMonitor()
        }
    }
}
