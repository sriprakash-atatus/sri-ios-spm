/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - rebranded the licence header.

import UIKit

/// The VC presented modally.
class RUMMVSModalViewController: UIViewController {
    @IBAction func didTapDismissUsingSelf(_ sender: Any) {
        if Bool.random() {
            dismiss(animated: true) { /* empty completion block */ }
        } else {
            dismiss(animated: true)
        }
    }

    @IBAction func didTapDismissUsingParent(_ sender: Any) {
        let presentingNavigationController = (presentingViewController as! UINavigationController)
        let presentingViewController = (presentingNavigationController.viewControllers[0] as! RUMMVSViewController)
        presentingViewController.dismissPresentedViewController()
    }
}
