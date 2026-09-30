/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; renamed
// `dd*` types to `TowerSignal*`; rebranded the licence header.

import TowerSignalInternal

internal final class ContextSharingFeature: TowerSignalFeature {
    static var name: String = "_extension_context_sharing"

    var messageReceiver: FeatureMessageReceiver

    init(messageReceiver: FeatureMessageReceiver) {
        self.messageReceiver = messageReceiver
    }
}
