/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - rebranded the licence header.

import UIKit
import SwiftUI

/// Used to display a SwiftUI view (``RUMAlertSwiftUI``) in `RUMAlertScenario` storyboard.
class RUMAlertSwiftUIViewController: UIHostingController<RUMAlertSwiftUI> {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: RUMAlertSwiftUI())
    }

}

