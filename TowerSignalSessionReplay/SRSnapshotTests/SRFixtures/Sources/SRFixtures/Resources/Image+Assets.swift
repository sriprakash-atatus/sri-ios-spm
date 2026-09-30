/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - rebranded the licence header.

import SwiftUI

@available(iOS 13.0, *)
extension Image {
    public static var towersignalLogo: Image {
        Image("dd_logo", bundle: .module)
    }

    public static var flowers: Image {
        Image("Flowers_1", bundle: .module)
    }
}
