/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; rebranded the
// licence header.

import Foundation
import TowerSignalInternal

internal protocol AnonymousIdentifierManaging {
    func manageAnonymousIdentifier(shouldTrack: Bool)
}

internal class AnonymousIdentifierManager: AnonymousIdentifierManaging {
    private let featureScope: FeatureScope
    private let uuidGenerator: RUMUUIDGenerator

    init(
        featureScope: FeatureScope,
        uuidGenerator: RUMUUIDGenerator
    ) {
        self.featureScope = featureScope
        self.uuidGenerator = uuidGenerator
    }

    func manageAnonymousIdentifier(shouldTrack: Bool) {
        if shouldTrack {
            featureScope.rumDataStore.value(forKey: .anonymousId) { [weak self] (anonymousId: String?) in
                if let anonymousId {
                    self?.featureScope.set(anonymousId: anonymousId)
                } else {
                    let anonymousId = self?.uuidGenerator.generateUnique().toRUMDataFormat
                    self?.featureScope.rumDataStore.setValue(anonymousId, forKey: .anonymousId)
                    self?.featureScope.set(anonymousId: anonymousId)
                }
            }
        } else {
            featureScope.rumDataStore.removeValue(forKey: .anonymousId)
            featureScope.set(anonymousId: nil)
        }
    }
}
