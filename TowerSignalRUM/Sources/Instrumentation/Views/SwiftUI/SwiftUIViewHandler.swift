/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; rebranded the
// licence header.

import Foundation
import TowerSignalInternal

/// Publisher generating RUM Commands on `SwiftUI.View` events.
internal protocol SwiftUIViewHandler: RUMCommandPublisher {
    /// Respond to a `SwiftUI.View.onAppear` event.
    func notify_onAppear(identity: String, name: String, path: String, attributes: [AttributeKey: AttributeValue])

    /// Respond to a `SwiftUI.View.onDisappear` event.
    func notify_onDisappear(identity: String)
}
