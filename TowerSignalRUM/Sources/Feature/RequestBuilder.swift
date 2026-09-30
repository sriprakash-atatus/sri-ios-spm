/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; renamed
// `dd*` types to `TowerSignal*`; renamed `dd*` members to `at*`; renamed `clientToken` to `licenseKey`;
// renamed the `ddsource` / `ddtags` query parameters to `towersignal_source` / `towersignaltags`; moved the intake
// path to `/v1/ios/*`; rebranded the licence header.

import Foundation
import TowerSignalInternal

/// The RUM URL Request Builder for formatting and configuring the `URLRequest`
/// to upload RUM data.
internal struct RequestBuilder: FeatureRequestBuilder {
    /// A custom RUM intake.
    let customIntakeURL: URL?

    /// The RUM view events filter from the payload.
    let eventsFilter: RUMViewEventsFilter

    /// The RUM request body format.
    let format = DataFormat(prefix: "", suffix: "", separator: "\n")

    /// Telemetry interface.
    let telemetry: Telemetry

    func request(
        for events: [Event],
        with context: TowerSignalContext,
        execution: ExecutionContext
    ) throws -> URLRequest {
        let filteredEvents = eventsFilter.filter(events: events)

        guard !filteredEvents.isEmpty else {
            throw InternalError(description: "All \(events.count) RUM events were filtered out, resulting in empty payload")
        }

        let data = format.format(filteredEvents.map { $0.data })

        let builder = URLRequestBuilder(
            url: url(with: context),
            // ATCHG: Added the TowerSignal identification query items (license key, agent name,
            // agent version, app name), matching `buildUrl()` in Android's `RumRequestFactory`.
            queryItems: [
                .towersignalSource(source: context.source),
                .licenseKey(licenseKey: context.licenseKey),
                .agentName(agentName: AgentInfo.agentName),
                .agentVersion(agentVersion: AgentInfo.agentVersion),
                .appName(appName: context.appName ?? context.service)
            ] + execution.retryQueryItems,
            // ATCHG: End
            headers: [
                .contentTypeHeader(contentType: .textPlainUTF8),
                .userAgentHeader(
                    appName: context.applicationName,
                    appVersion: context.version,
                    device: context.device,
                    os: context.os
                ),
                .atAPIKeyHeader(licenseKey: context.licenseKey),
                .atEVPOriginHeader(source: context.ciAppOrigin ?? context.source),
                .atEVPOriginVersionHeader(sdkVersion: context.sdkVersion),
                .atRequestIDHeader(),
                .atIdempotencyKeyHeader(key: data.sha1())
            ],
            telemetry: telemetry
        )

        return builder.uploadRequest(with: data)
    }

    private func url(with context: TowerSignalContext) -> URL {
        // ATCHG: TowerSignal RUM intake path, matching `/v1/android/rum` in Android's `RumRequestFactory`.
        // Built from `intakeEndpoint` so a custom `serverUrl` is honoured, as on Android.
        customIntakeURL ?? context.intakeEndpoint.appendingPathComponent("v1/android/rum")
        // ATCHG: End
    }
}
