/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; renamed
// `dd*` types to `TowerSignal*`; rebranded the licence header.

import Foundation
import TowerSignalInternal

internal struct ErrorMessageReceiver: FeatureMessageReceiver {
    /// RUM feature scope.
    let featureScope: FeatureScope
    let monitor: Monitor

    /// Adds RUM Error with given message and stack to current RUM View.
    func receive(message: FeatureMessage, from core: TowerSignalCoreProtocol) -> Bool {
        guard case let .payload(error as RUMErrorMessage) = message else {
            return false
        }

        monitor._internal?.addError(
            at: error.time,
            message: error.message,
            type: error.type,
            stack: error.stack,
            source: .init(rawValue: error.source) ?? .custom,
            globalAttributes: [:],
            attributes: error.attributes,
            binaryImages: error.binaryImages
        )

        return true
    }
}
