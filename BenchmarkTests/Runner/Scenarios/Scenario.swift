/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - rebranded the `dd` name to `TowerSignal` in comments and docs; rebranded
// the licence header.

import Foundation
import UIKit

/// A `Scenario` is the entry-point of the Benchmark Runner Application.
///
/// The compliant objects are responsible for initializing the SDK, enabling
/// Features, and create the initial view-controller.
protocol Scenario {
    /// The initial view-controller of the scenario
    var initialViewController: UIViewController { get }

    /// Start instrumenting the application by enabling the TowerSignal SDK and
    /// its Features.
    ///
    /// - Parameter info: The application information to use during SDK
    /// initialisation.
    func instrument(with info: AppInfo)
}
