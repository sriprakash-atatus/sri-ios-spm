/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - rebranded the licence header.

import UIKit

public final class TabbarViewControllers: UIViewController {
    @IBOutlet var tabbars: [UITabBar]!

    override public func viewDidLoad() {
        for tabbar in tabbars {
            // Select the first tabbar's item
            // so we can see both a selected and unselected item
            tabbar.selectedItem = tabbar.items?.first
        }
    }
}

public final class EmbeddedTabbarController: UITabBarController {
    override public func viewDidLoad() {
        tabBar.unselectedItemTintColor = nil
    }
}

public final class EmbeddedTabbarUnselectedTintColorController: UITabBarController {
    override public func viewDidLoad() {
        tabBar.unselectedItemTintColor = UIColor.green
    }
}
