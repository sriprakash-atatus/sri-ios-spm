/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; rebranded the
// licence header.

import Foundation
import TowerSignalInternal

/// Publishes the user consent to receiver.
internal final class TrackingConsentPublisher: ContextValuePublisher {
    let initialValue: TrackingConsent

    private var receiver: ContextValueReceiver<TrackingConsent>?

    var consent: TrackingConsent {
        didSet { receiver?(consent) }
    }

    init(consent: TrackingConsent) {
        self.initialValue = consent
        self.consent = consent
    }

    func publish(to receiver: @escaping ContextValueReceiver<TrackingConsent>) {
        self.receiver = receiver
    }

    func cancel() {
        receiver = nil
    }
}
