/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; renamed
// `dd*` types to `TowerSignal*`; rebranded the licence header.

import TowerSignalInternal

internal final class ProfilingContextMessageReceiver: FeatureMessageReceiver {
    let profilingSamplerProvider: ProfilingSamplerProvider

    init(profilingSamplerProvider: ProfilingSamplerProvider) {
        self.profilingSamplerProvider = profilingSamplerProvider
    }

    func receive(message: FeatureMessage, from core: TowerSignalCoreProtocol) -> Bool {
        guard case let .context(context) = message,
              let deterministicSampler = context.additionalContext(ofType: RUMCoreContext.self)?.sessionSampler else {
            return false
        }

        profilingSamplerProvider.updateWith(deterministicSampler: deterministicSampler)

        return false
    }
}
