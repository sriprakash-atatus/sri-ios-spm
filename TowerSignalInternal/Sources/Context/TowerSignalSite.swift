/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

import Foundation

// ATCHG: Replaced the multi-region dd site list (us1/us3/us5/eu1/ap1/ap2/uk1/us1_fed/us2_fed)
// with the single TowerSignal intake site, mirroring `TowerSignalSite` in the TowerSignal Android agent.
/// Defines the TowerSignal site you can send tracked data to.
public enum TowerSignalSite: String {
    /// The TowerSignal site: [mo-rx.towersignal.com](https://mo-rx.towersignal.com).
    case towersignal

    // ATCHG: Added `serverUrl` override so the intake host can be pointed at a testing
    // endpoint (e.g. ngrok) without hardcoding, matching `TowerSignalSite.serverUrl` on Android.
    /// Global override for the intake endpoint.
    ///
    /// Defaults to the `TOWERSIGNAL_SERVER_URL` environment variable when present. When set, it takes
    /// precedence over the site's default intake host.
    @ReadWriteLock
    public static var serverUrl: String? = ProcessInfo.processInfo.environment["TOWERSIGNAL_SERVER_URL"]
    // ATCHG: End
}
// ATCHG: End

extension TowerSignalSite {
    // ATCHG: Default production intake host for the TowerSignal site.
    /// The host name of the intake for this site.
    private var intakeHostName: String {
        switch self {
        case .towersignal: return "mo-rx.towersignal.com"
        }
    }
    // ATCHG: End

    /// The intake endpoint URL.
    public var endpoint: URL {
        // ATCHG: Resolve the global `serverUrl` first so config-driven endpoints win over the default host.
        if let overrideURL = TowerSignalSite.normalizedServerURL(TowerSignalSite.serverUrl) {
            return overrideURL
        }
        // ATCHG: End
        // swiftlint:disable:next force_unwrapping
        return URL(string: "https://\(intakeHostName)")!
    }

    // ATCHG: Added the intake base url resolution shared by every feature, matching
    // `val TowerSignalContext.intakeEndpoint` in the TowerSignal Android agent
    // (`towersignal-sdk-android-core/src/main/kotlin/com/towersignal/android/api/context/TowerSignalContext.kt`).
    /// Resolves the base url every intake request is built from.
    ///
    /// Precedence, highest first:
    /// 1. `serverUrl` — the per-instance custom intake set through `TowerSignal.Configuration.serverUrl`.
    /// 2. ``TowerSignalSite/serverUrl`` — the global override, defaulting to the `TOWERSIGNAL_SERVER_URL`
    ///    environment variable.
    /// 3. The site's default intake host.
    ///
    /// A `serverUrl` that is blank, or that does not parse into an absolute url with a scheme and a
    /// host, is ignored and the next option is used.
    ///
    /// - Parameters:
    ///   - serverUrl: The custom intake base url, if one was configured.
    ///   - site: The site to fall back to.
    /// - Returns: The base url, never with a trailing slash. Features append their own path to it.
    public static func intakeEndpoint(serverUrl: String?, site: TowerSignalSite) -> URL {
        normalizedServerURL(serverUrl) ?? site.endpoint
    }

    /// Parses a custom intake base url, rejecting the values that cannot serve as one.
    ///
    /// Trailing slashes are dropped so that appending a feature path does not produce a double
    /// slash, mirroring the `serverUrl?.trimEnd('/')` normalisation done by
    /// `Configuration.Builder.setServerUrl` on Android.
    internal static func normalizedServerURL(_ serverUrl: String?) -> URL? {
        guard let serverUrl = serverUrl else {
            return nil
        }

        var base = serverUrl.trimmingCharacters(in: .whitespacesAndNewlines)
        while base.hasSuffix("/") {
            base.removeLast()
        }

        guard
            !base.isEmpty,
            let url = URL(string: base),
            url.scheme != nil,
            url.host != nil
        else {
            return nil
        }

        return url
    }
    // ATCHG: End
}
