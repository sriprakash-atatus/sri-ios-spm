/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed `dd*` types to `TowerSignal*`; rebranded the `dd` name to
// `TowerSignal` in comments and docs; rebranded the licence header.

import Foundation

/// A TowerSignal Feature that can interact with the core through the message-bus.
public protocol TowerSignalFeature {
    /// The feature name.
    static var name: String { get }

    /// The message bus receiver.
    ///
    /// The `FeatureMessageReceiver` defines an interface for Feature to receive any message
    /// from a bus that is shared between Features registered in a core.
    var messageReceiver: FeatureMessageReceiver { get }
}

/// A TowerSignal Feature with remote data store.
public protocol TowerSignalRemoteFeature: TowerSignalFeature {
    /// The URL request builder for uploading data.
    ///
    /// The `FeatureRequestBuilder` defines an interface for building a single `URLRequest`
    /// for a list of data events and the current core context.
    ///
    /// A Feature should use this interface for creating requests that needs be sent to its TowerSignal Intake.
    /// The request will be transported by `TowerSignalCore`.
    var requestBuilder: FeatureRequestBuilder { get }

    /// (Optional) `PerformancePresetOverride` allows overriding certain performance presets if needed.
    var performanceOverride: PerformancePresetOverride? { get }
}
