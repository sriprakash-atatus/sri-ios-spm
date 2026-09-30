/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; renamed
// `dd*` types to `TowerSignal*`; rebranded the licence header.

import Foundation
import TowerSignalInternal

extension Logs: InternalExtended {}

extension InternalExtension where ExtendedType == Logs {
    /// Check whether `Logs` has been enabled for a specific SDK instance.
    /// 
    /// - Parameters:
    ///    - in: the core to check
    ///
    /// - Returns: true if `Logs` has been enabled for the supplied core.
    public static func isEnabled(in core: TowerSignalCoreProtocol = CoreRegistry.default) -> Bool {
        return core.get(feature: LogsFeature.self) != nil
    }
}
