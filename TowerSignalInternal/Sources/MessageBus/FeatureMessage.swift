/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed `dd*` types to `TowerSignal*`; rebranded the licence header.

import Foundation

/// The set of messages that can be transmitted on the Features message bus.
public enum FeatureMessage {
    /// A custom payload message.
    case payload(Any)

    /// A web-view message.
    ///
    /// Represent a Browser SDK event sent through the JS bridge.
    case webview(WebViewMessage)

    /// Session Replay records produced by an embedded renderer.
    case embeddedContent(EmbeddedContentMessage)

    /// A core context message.
    ///
    /// The core will send updated context through the bus. Do not send new context values
    /// from a Feature or Integration.
    case context(TowerSignalContext)

    /// A telemetry message.
    ///
    /// The core can send telemetry data coming from all Features.
    case telemetry(TelemetryMessage)
}
