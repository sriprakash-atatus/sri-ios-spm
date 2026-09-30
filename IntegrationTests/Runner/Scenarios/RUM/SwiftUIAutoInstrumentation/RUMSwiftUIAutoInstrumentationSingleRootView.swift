
/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - rebranded the licence header.

import Foundation
import SwiftUI

// MARK: - SwiftUIAutoInstrumentationSingleRootView

@available(iOS 16.0, *)
class SwiftUIAutoInstrumentationSingleRootView: UIHostingController<NavigationStackExample> {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: NavigationStackExample())
    }
}
