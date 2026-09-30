/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - rebranded the licence header.

#if os(iOS)
import QuartzCore
import UIKit

/// Provides the root layer for a layer tree capture.
@available(iOS 13.0, tvOS 13.0, *)
internal protocol LayerProvider {
    @MainActor var rootLayer: CALayer? { get }
}

@available(iOS 13.0, tvOS 13.0, *)
extension KeyWindowObserver: LayerProvider {
    var rootLayer: CALayer? {
        relevantWindow?.layer
    }
}
#endif
