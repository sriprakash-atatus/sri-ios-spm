/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - rebranded the licence header.

import SwiftUI
import SRFixtures

struct SwiftUIFixture: FixtureProtocol {
    private let _instantiateViewController: () -> UIViewController

    init<Content: View>(@ViewBuilder content: @escaping () -> Content) {
        _instantiateViewController = {
            UIHostingController(rootView: content())
        }
    }

    func instantiateViewController() -> UIViewController {
        _instantiateViewController()
    }
}
