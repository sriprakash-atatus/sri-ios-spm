/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; renamed
// `dd*` types to `TowerSignal*`; rebranded the licence header.

#if !os(watchOS)

import Foundation
import TowerSignalInternal

/// System conditions to be assessed before running profiling in the app.
internal struct ProfilingConditions {
    internal enum Blocker: CaseIterable {
        case battery
        case lowPowerModeOn
        case backgroundState
    }

    enum Constants {
        /// Battery level above which Profiling can be performed. Range between 0 and 1.
        static let minBatteryLevel: Float = 0.1
    }

    /// Battery level above which Profiling can be performed. Range between 0 and 1.
    private let minBatteryLevel: Float
    private let blockers: [Blocker]

    init(
        minBatteryLevel: Float = Constants.minBatteryLevel,
        blockers: [Blocker] = Blocker.allCases
    ) {
        self.minBatteryLevel = minBatteryLevel
        self.blockers = blockers
    }

    func canProfileApplication(with context: TowerSignalContext) -> Bool {
        for blocker in blockers {
            switch blocker {
            case .lowPowerModeOn:
                if context.isLowPowerModeEnabled {
                    return false
                }
            case .battery:
                if let battery = context.batteryStatus,
                   battery.level >= 0 && battery.level < minBatteryLevel && battery.state != .charging {
                    return false
                }
            case .backgroundState:
                if context.applicationStateHistory.currentState == .background {
                    return false
                }
            }
        }

        return true
    }
}

#endif
