/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; renamed
// `dd*` types to `TowerSignal*`; rebranded the licence header.

import Foundation
import TowerSignalInternal

/// `FeatureMessageReceiver` that records received telemetry events.
public class TelemetryReceiverMock: FeatureMessageReceiver {
    @ReadWriteLock
    public private(set) var messages: [TelemetryMessage] = []

    public init() {}

    public func receive(message: FeatureMessage, from core: TowerSignalCoreProtocol) -> Bool {
        guard case let .telemetry(message) = message else {
            return false
        }

        messages.append(message)
        return true
    }
}
