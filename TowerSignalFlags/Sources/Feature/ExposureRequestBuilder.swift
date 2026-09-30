/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; renamed
// `dd*` types to `TowerSignal*`; renamed `dd*` members to `at*`; renamed `clientToken` to `licenseKey`;
// renamed the `ddsource` / `ddtags` query parameters to `towersignal_source` / `towersignaltags`; rebranded the
// licence header.

import Foundation
import TowerSignalInternal

internal struct ExposureRequestBuilder: FeatureRequestBuilder {
    /// A custom RUM intake.
    let customIntakeURL: URL?

    /// The exposure request body format.
    let format = DataFormat(prefix: "", suffix: "", separator: "\n")

    /// Telemetry interface.
    let telemetry: Telemetry

    func request(for events: [Event], with context: TowerSignalContext, execution: ExecutionContext) throws -> URLRequest {
        let builder = URLRequestBuilder(
            url: url(with: context),
            queryItems: [
                .towersignalSource(source: context.source)
            ],
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
                .atRequestIDHeader()
            ],
            telemetry: telemetry
        )
        let data = format.format(events.map(\.data))
        return builder.uploadRequest(with: data, compress: false)
    }

    private func url(with context: TowerSignalContext) -> URL {
        // ATCHG: Built from `intakeEndpoint` so a custom `serverUrl` is honoured, matching
        // `ExposuresRequestFactory.create` on Android.
        customIntakeURL ?? context.intakeEndpoint.appendingPathComponent("api/v2/exposures")
        // ATCHG: End
    }
}
