/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; renamed the
// `DD` symbol prefix to `AT`; rebranded the `dd` name to `TowerSignal` in comments and docs; rebranded the
// licence header.

import Foundation
import TowerSignalInternal

#if canImport(WebKit)
import WebKit

@objc(ATWebViewTracking)
@_spi(objc)
public final class objc_WebViewTracking: NSObject {
    override private init() { }

    /// Enables SDK to correlate TowerSignal RUM events and Logs from the WebView with native RUM session.
    ///
    /// If the content loaded in WebView uses TowerSignal Browser SDK (`v4.2.0+`) and matches specified
    /// `hosts`, web events will be correlated with the RUM session from native SDK.
    ///
    /// Each entry in `hosts` can be a plain hostname (`"example.com"`) or a wildcard pattern with a
    /// single `*` (`"*.example.com"`, `"preview-*.shopist.io"`). Invalid entries are dropped with a warning.
    ///
    /// - Parameters:
    ///   - webView: The web-view to track.
    ///   - hosts: A set of hosts or wildcard patterns instrumented with Browser SDK to capture TowerSignal events from.
    ///   - logsSampleRate: The sampling rate for logs coming from the WebView. Must be a value between `0` and `100`,
    ///   where 0 means no logs will be sent and 100 means all will be uploaded. Default: `100`.
    @objc
    public static func enable(
        webView: WKWebView,
        hosts: Set<String> = [],
        logsSampleRate: SampleRate = .maxSampleRate
    ) {
        WebViewTracking.enable(
            webView: webView,
            hosts: hosts,
            logsSampleRate: logsSampleRate
        )
    }

    /// Enables SDK to correlate TowerSignal RUM events and Logs from the WebView with native RUM session on a named SDK instance.
    ///
    /// If the content loaded in WebView uses TowerSignal Browser SDK (`v4.2.0+`) and matches specified
    /// `hosts`, web events will be correlated with the RUM session from native SDK.
    ///
    /// - Parameters:
    ///   - webView: The web-view to track.
    ///   - instanceName: The name of the SDK instance to use for tracking.
    ///   - hosts: A set of hosts instrumented with Browser SDK to capture TowerSignal events from.
    ///   - logsSampleRate: The sampling rate for logs coming from the WebView. Must be a value between `0` and `100`,
    ///   where 0 means no logs will be sent and 100 means all will be uploaded. Default: `100`.
    @objc
    public static func enable(
        webView: WKWebView,
        instanceName: String?,
        hosts: Set<String> = [],
        logsSampleRate: SampleRate = .maxSampleRate
    ) {
        WebViewTracking.enable(
            webView: webView,
            hosts: hosts,
            logsSampleRate: logsSampleRate,
            in: CoreRegistry.instance(named: instanceName ?? CoreRegistry.defaultInstanceName)
        )
    }

    /// Disables TowerSignal iOS SDK and TowerSignal Browser SDK integration.
    ///
    /// Removes TowerSignal's ScriptMessageHandler and UserScript from the caller.
    /// - Note: This method **must** be called when the webview can be deinitialized.
    ///
    /// - Parameter webView: The web-view to stop tracking.
    @objc
    public static func disable(
        webView: WKWebView
    ) {
        WebViewTracking.disable(webView: webView)
    }
}
#endif
