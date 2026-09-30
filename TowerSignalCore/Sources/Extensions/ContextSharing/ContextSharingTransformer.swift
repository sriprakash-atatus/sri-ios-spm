/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; renamed
// `dd*` types to `TowerSignal*`; rebranded the licence header.

import TowerSignalInternal

internal final class ContextSharingTransformer: FeatureMessageReceiver, ContextValuePublisher {
    @ReadWriteLock
    private var sharedContext: SharedContext? = nil
    @ReadWriteLock
    private var receiver: ContextValueReceiver<SharedContext?>? = nil

    // MARK: - FeatureMessageReceiver

    func receive(message: FeatureMessage, from core: TowerSignalCoreProtocol) -> Bool {
        switch message {
        case .context(let context):
            let newContext = SharedContext(towersignalContext: context)
            sharedContext = newContext
            receiver?(newContext)
            return true
        default:
            return false
        }
    }

    // MARK: - ContextValuePublisher

    var initialValue: SharedContext? = nil

    func publish(to receiver: @escaping ContextValueReceiver<SharedContext?>) {
        self.receiver = receiver
        receiver(sharedContext)
    }

    func cancel() {
        receiver = nil
    }
}
