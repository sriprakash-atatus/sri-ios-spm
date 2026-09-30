/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; renamed
// `dd*` types to `TowerSignal*`; rebranded the `dd` name to `TowerSignal` in comments and docs; rebranded
// the licence header.

import Foundation
@_spi(Internal)
import TowerSignalInternal

extension RUM: InternalExtended {}

/// NOTE: Methods in this extension are NOT considered part of the public of the TowerSignal SDK, and
/// may change or be removed in minor updates of the TowerSignal SDK.
extension InternalExtension where ExtendedType == RUM {
    /// Check whether `RUM` has been enabled for a specific SDK instance.
    ///
    /// - Parameters:
    ///    - in: the core to check
    ///
    /// - Returns: true if `RUM` has been enabled for the supplied core.
    public static func isEnabled(in core: TowerSignalCoreProtocol = CoreRegistry.default) -> Bool {
        return core.get(feature: RUMFeature.self) != nil
    }

    /// Enable URL session tracking after RUM has already been enabled. This method
    /// is only needed if the configuration of URL session tracking is not known at initialization time,
    /// or in the case of cross platform frameworks that do not initialize native URL session tracking.
    ///
    /// - Parameters:
    ///    - configuration: the configuration for URL session tracking
    ///    - in: the core to enable URL session in
    public static func enableURLSessionTracking(
        with configuration: RUM.Configuration.URLSessionTracking,
        in core: TowerSignalCoreProtocol = CoreRegistry.default) throws {
        guard !(core is NOPTowerSignalCore) else {
            throw ProgrammerError(
                description: "TowerSignal SDK and RUM must be initialized before calling `RUM.enableUrlSessionTracking`."
            )
        }

        guard let rum = core.get(feature: RUMFeature.self) else {
            throw ProgrammerError(
                description: "RUM must be initialized before calling `RUM.enableUrlSessionTracking`."
            )
        }

        let distributedTracing: DistributedTracing?
        let rumConfiguration = rum.configuration

        // If first party hosts are configured, enable distributed tracing:
        switch configuration.firstPartyHostsTracing {
        case let .trace(hosts, sampleRate, traceContextInjection):
            distributedTracing = DistributedTracing(
                samplingRate: rumConfiguration.debugSDK ? 100 : sampleRate,
                firstPartyHosts: FirstPartyHosts(hosts),
                traceIDGenerator: rumConfiguration.traceIDGenerator,
                spanIDGenerator: rumConfiguration.spanIDGenerator,
                traceContextInjection: traceContextInjection
            )
        case let .traceWithHeaders(hostsWithHeaders, sampleRate, traceContextInjection):
            distributedTracing = DistributedTracing(
                samplingRate: rumConfiguration.debugSDK ? 100 : sampleRate,
                firstPartyHosts: FirstPartyHosts(hostsWithHeaders),
                traceIDGenerator: rumConfiguration.traceIDGenerator,
                spanIDGenerator: rumConfiguration.spanIDGenerator,
                traceContextInjection: traceContextInjection
            )
        case .none:
            distributedTracing = nil
        }

        let headerProcessor: HeaderProcessor? = {
            switch configuration.trackResourceHeaders {
            case .disabled:
                return nil
            case .defaults, .custom:
                return HeaderProcessor(config: configuration.trackResourceHeaders)
            }
        }()

        let urlSessionHandler = URLSessionRUMResourcesHandler(
            dateProvider: rumConfiguration.dateProvider,
            rumAttributesProvider: configuration.resourceAttributesProvider,
            distributedTracing: distributedTracing,
            headerProcessor: headerProcessor,
            telemetry: core.telemetry
        )

        // Connect URLSession instrumentation to RUM monitor:
        urlSessionHandler.publish(to: rum.monitor)
        try core.register(urlSessionHandler: urlSessionHandler)

        // Enable automatic network tracking (no delegate registration required)
        try URLSessionInstrumentation.enableOrThrow(with: nil, in: core)
    }
}
