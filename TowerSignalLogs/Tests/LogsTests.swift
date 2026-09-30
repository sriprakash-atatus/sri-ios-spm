/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`, `ddLogs`
// -> `TowerSignalLogs`; rebranded the licence header.

import XCTest
@_spi(Internal)
import TowerSignalInternal
import TestUtilities

@testable import TowerSignalLogs

class LogsTests: XCTestCase {
    func testDefaultConfiguration() {
        // Given
        let config = Logs.Configuration()

        // Then
        XCTAssertNil(config.eventMapper)
        XCTAssertNil(config.customEndpoint)
    }

    func testWhenNotEnabled_thenLogsIsEnabledIsFalse() {
        // When
        let core = FeatureRegistrationCoreMock()
        XCTAssertNil(core.get(feature: LogsFeature.self))

        // Then
        XCTAssertFalse(Logs._internal.isEnabled(in: core))
    }

    func testWhenEnabled_thenLogsIsEnabledIsTrue() {
        // When
        let core = FeatureRegistrationCoreMock()
        let config = Logs.Configuration()
        Logs.enable(with: config, in: core)

        // Then
        XCTAssertTrue(Logs._internal.isEnabled(in: core))
    }

    func testInitializedWithBacktraceReporter() throws {
        // Given
        let core = FeatureRegistrationCoreMock()

        // When
        Logs.enable(in: core)

        // Then
        let logs = try XCTUnwrap(core.get(feature: LogsFeature.self))
        XCTAssertNotNil(logs.backtraceReporter)
    }

    func testConfigurationOverrides() throws {
        // Given
        let customEndpoint: URL = .mockRandom()

        let core = SingleFeatureCoreMock<LogsFeature>()

        // When
        Logs.enable(
            with: Logs.Configuration(
                eventMapper: { $0 },
                customEndpoint: customEndpoint
            ),
            in: core
        )

        // Then
        let logs = try XCTUnwrap(core.get(feature: LogsFeature.self))
        let requestBuilder = try XCTUnwrap(logs.requestBuilder as? RequestBuilder)
        XCTAssertNotNil(logs.logEventMapper)
        XCTAssertEqual(requestBuilder.customIntakeURL, customEndpoint)
    }

    func testConfigurationInternalOverrides() throws {
        struct LogEventMapperMock: LogEventMapper {
            func map(event: TowerSignalLogs.LogEvent, callback: @escaping (TowerSignalLogs.LogEvent) -> Void) {
                callback(event)
            }
        }

        // Given
        let eventMapper = LogEventMapperMock()
        var config = Logs.Configuration()

        // When
        config._internal_mutation {
            $0.setLogEventMapper(eventMapper)
        }

        // Then
        XCTAssertTrue(config._internalEventMapper is LogEventMapperMock)
    }

    func testLogsAddAttributeForwardedToFeature() throws {
        // Given
        let core = FeatureRegistrationCoreMock()
        let config = Logs.Configuration()
        Logs.enable(with: config, in: core)

        // When
        let attributeKey: String = .mockRandom()
        let attributeValue: String = .mockRandom()
        Logs.addAttribute(forKey: attributeKey, value: attributeValue, in: core)

        // Then
        let feature = try XCTUnwrap(core.get(feature: LogsFeature.self))
        XCTAssertEqual(feature.attributes.getAttributes()[attributeKey] as? String, attributeValue)
    }

    func testLogsRemoveAttributeForwardedToFeature() throws {
        // Given
        let core = FeatureRegistrationCoreMock()
        let config = Logs.Configuration()
        Logs.enable(with: config, in: core)
        let attributeKey: String = .mockRandom()
        let attributeValue: String = .mockRandom()
        Logs.addAttribute(forKey: attributeKey, value: attributeValue, in: core)

        // When
        Logs.removeAttribute(forKey: attributeKey, in: core)

        // Then
        let feature = try XCTUnwrap(core.get(feature: LogsFeature.self))
        XCTAssertNil(feature.attributes.getAttributes()[attributeKey])
    }

    func testItSendsGlobalLogUpdates_whenAddAttribute() throws {
        // Given
        let mockMessageReceiver = FeatureMessageReceiverMock()
        let core = SingleFeatureCoreMock<LogsFeature>(
            messageReceiver: mockMessageReceiver
        )
        let config = Logs.Configuration()
        Logs.enable(with: config, in: core)

        // When
        let attributeKey: String = .mockRandom()
        let attributeValue: String = .mockRandom()
        Logs.addAttribute(forKey: attributeKey, value: attributeValue, in: core)

        // Then
        let messages = mockMessageReceiver.messages.compactMap { $0.asPayload as? LogEventAttributes }
        XCTAssertEqual(messages.count, 1)
        let message = try XCTUnwrap(messages.first)
        XCTAssertEqual(message.attributes[attributeKey] as? String, attributeValue)
    }

    func testItSendsGlobalLogUpdates_whenRemoveAttribute() throws {
        // Given
        let mockMessageReceiver = FeatureMessageReceiverMock()
        let core = SingleFeatureCoreMock<LogsFeature>(
            messageReceiver: mockMessageReceiver
        )
        let config = Logs.Configuration()
        Logs.enable(with: config, in: core)
        let attributeKey: String = .mockRandom()
        let attributeValue: String = .mockRandom()
        Logs.addAttribute(forKey: attributeKey, value: attributeValue, in: core)

        // When
        Logs.removeAttribute(forKey: attributeKey, in: core)

        // Then
        let messages = mockMessageReceiver.messages.compactMap { $0.asPayload as? LogEventAttributes }
        XCTAssertEqual(messages.count, 2)
        let message = try XCTUnwrap(messages.last)
        XCTAssertNil(message.attributes[attributeKey])
    }
}

// ATCHG: Tests covering the TowerSignal changes ported from the Android agent's `LogsRequestFactory`:
// the `/v1/android/logs` intake path, the agent identification headers and query parameters, and the
// logs heartbeat gate.
class TowerSignalLogsRequestBuilderTests: XCTestCase {
    private let mockEvents: [Event] = [.init(data: "{}".utf8Data)]

    override func setUp() {
        super.setUp()
        LogsHeartbeatScheduler.setLogsAllowed(true)
    }

    override func tearDown() {
        LogsHeartbeatScheduler.setLogsAllowed(false)
        super.tearDown()
    }

    func testItSetsTheTowerSignalLogsIntakeURL() throws {
        // Given
        let builder = RequestBuilder(customIntakeURL: nil, telemetry: NOPTelemetry())

        // When
        let request = try builder.request(for: mockEvents, with: .mockWith(site: .towersignal), execution: .mockAny())

        // Then
        XCTAssertEqual(request.url?.absoluteStringWithoutQuery, "https://mo-rx.towersignal.com/v1/android/logs")
    }

    func testItSetsTheTowerSignalQueryParametersAndHeaders() throws {
        // Given
        let randomLicenseKey: String = .mockRandom(among: .alphanumerics)
        let randomAppName: String = .mockRandom(among: .alphanumerics)
        let randomSource: String = .mockRandom(among: .alphanumerics)
        let builder = RequestBuilder(customIntakeURL: nil, telemetry: NOPTelemetry())
        let context: TowerSignalContext = .mockWith(
            licenseKey: randomLicenseKey,
            appName: randomAppName,
            source: randomSource
        )

        // When
        let request = try builder.request(for: mockEvents, with: context, execution: .mockAny())

        // Then
        let components = try XCTUnwrap(URLComponents(url: try XCTUnwrap(request.url), resolvingAgainstBaseURL: false))
        let query = (components.queryItems ?? []).reduce(into: [String: String]()) { $0[$1.name] = $1.value }
        XCTAssertEqual(query["towersignal_source"], randomSource)
        XCTAssertEqual(query["license_key"], randomLicenseKey)
        XCTAssertEqual(query["agent_name"], AgentInfo.agentName)
        XCTAssertEqual(query["agent_version"], AgentInfo.agentVersion)
        XCTAssertEqual(query["app_name"], randomAppName)

        XCTAssertEqual(request.allHTTPHeaderFields?["api-key"], randomLicenseKey)
        XCTAssertEqual(request.allHTTPHeaderFields?["TOWERSIGNAL-AGENT-NAME"], AgentInfo.agentName)
        XCTAssertEqual(request.allHTTPHeaderFields?["TOWERSIGNAL-AGENT-VERSION"], AgentInfo.agentVersion)
        XCTAssertEqual(request.allHTTPHeaderFields?["TOWERSIGNAL-APP-NAME"], randomAppName)
    }

    func testItSkipsTheBatchWhileTheLogsHeartbeatDisablesLogs() {
        // Given
        LogsHeartbeatScheduler.setLogsAllowed(false)
        let builder = RequestBuilder(customIntakeURL: nil, telemetry: NOPTelemetry())

        // When / Then
        XCTAssertThrowsError(try builder.request(for: mockEvents, with: .mockAny(), execution: .mockAny())) { error in
            XCTAssertTrue(error is LogsDisabledByHeartbeatError)
        }
    }
}
// ATCHG: End
