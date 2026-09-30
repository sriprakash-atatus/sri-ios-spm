/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

import XCTest
import TestUtilities
@testable import TowerSignalInternal

// ATCHG: New test file covering the TowerSignal-specific changes ported from the TowerSignal Android agent:
// the single TowerSignal site and its `serverUrl` override, the `AgentInfo` identity, the `agent`
// payload object, the renamed intake headers and query parameters, and the heartbeat request.

// MARK: - TowerSignalSite

class TowerSignalSiteTests: XCTestCase {
    override func tearDown() {
        TowerSignalSite.serverUrl = nil
        super.tearDown()
    }

    func testItDefinesOnlyTheTowerSignalSite() {
        XCTAssertEqual(TowerSignalSite.towersignal.rawValue, "towersignal")
    }

    func testItUsesTheTowerSignalIntakeHost() {
        TowerSignalSite.serverUrl = nil
        XCTAssertEqual(TowerSignalSite.towersignal.endpoint.absoluteString, "https://mo-rx.towersignal.com")
    }

    func testServerUrlOverridesTheIntakeHost() {
        TowerSignalSite.serverUrl = "https://example.ngrok.io"
        XCTAssertEqual(TowerSignalSite.towersignal.endpoint.absoluteString, "https://example.ngrok.io")
    }

    func testInvalidServerUrlFallsBackToTheIntakeHost() {
        TowerSignalSite.serverUrl = ""
        XCTAssertEqual(TowerSignalSite.towersignal.endpoint.absoluteString, "https://mo-rx.towersignal.com")
    }

    // MARK: - intakeEndpoint(serverUrl:site:)

    func testIntakeEndpointUsesTheSiteEndpointWhenNoServerUrlIsSet() {
        XCTAssertEqual(
            TowerSignalSite.intakeEndpoint(serverUrl: nil, site: .towersignal).absoluteString,
            "https://mo-rx.towersignal.com"
        )
    }

    func testIntakeEndpointUsesTheCustomServerUrl() {
        XCTAssertEqual(
            TowerSignalSite.intakeEndpoint(serverUrl: "https://rum.example.com", site: .towersignal).absoluteString,
            "https://rum.example.com"
        )
    }

    func testIntakeEndpointDropsTrailingSlashesFromTheCustomServerUrl() {
        XCTAssertEqual(
            TowerSignalSite.intakeEndpoint(serverUrl: "https://rum.example.com//", site: .towersignal).absoluteString,
            "https://rum.example.com"
        )
    }

    func testIntakeEndpointFallsBackToTheSiteEndpointOnBlankServerUrl() {
        for blank in ["", "   ", "\n"] {
            XCTAssertEqual(
                TowerSignalSite.intakeEndpoint(serverUrl: blank, site: .towersignal).absoluteString,
                "https://mo-rx.towersignal.com",
                "\"\(blank)\" should be ignored"
            )
        }
    }

    func testIntakeEndpointFallsBackToTheSiteEndpointOnMalformedServerUrl() {
        for malformed in ["not a url", "rum.example.com", "https://"] {
            XCTAssertEqual(
                TowerSignalSite.intakeEndpoint(serverUrl: malformed, site: .towersignal).absoluteString,
                "https://mo-rx.towersignal.com",
                "\"\(malformed)\" should be ignored"
            )
        }
    }

    func testCustomServerUrlTakesPrecedenceOverTheGlobalOverride() {
        TowerSignalSite.serverUrl = "https://global.ngrok.io"
        XCTAssertEqual(
            TowerSignalSite.intakeEndpoint(serverUrl: "https://rum.example.com", site: .towersignal).absoluteString,
            "https://rum.example.com"
        )
    }

    func testIntakeEndpointFallsBackToTheGlobalOverrideWhenNoCustomServerUrlIsSet() {
        TowerSignalSite.serverUrl = "https://global.ngrok.io"
        XCTAssertEqual(
            TowerSignalSite.intakeEndpoint(serverUrl: nil, site: .towersignal).absoluteString,
            "https://global.ngrok.io"
        )
    }
}

// MARK: - TowerSignalContext.intakeEndpoint

// ATCHG: Mirrors `TowerSignalContextTest` in the TowerSignal Android agent, which covers the same three
// cases for the `TowerSignalContext.intakeEndpoint` extension.
class TowerSignalContextIntakeEndpointTests: XCTestCase {
    override func tearDown() {
        TowerSignalSite.serverUrl = nil
        super.tearDown()
    }

    func testItUsesTheSiteEndpointWhenNoServerUrlIsSet() {
        let context = TowerSignalContext.mockWith(site: .towersignal, serverUrl: nil)
        XCTAssertEqual(context.intakeEndpoint, TowerSignalSite.towersignal.endpoint)
    }

    func testItUsesTheCustomServerUrl() {
        let context = TowerSignalContext.mockWith(site: .towersignal, serverUrl: "https://rum.example.com")
        XCTAssertEqual(context.intakeEndpoint.absoluteString, "https://rum.example.com")
    }

    func testItUsesTheSiteEndpointOnBlankServerUrl() {
        let context = TowerSignalContext.mockWith(site: .towersignal, serverUrl: "   ")
        XCTAssertEqual(context.intakeEndpoint, TowerSignalSite.towersignal.endpoint)
    }

    func testFeaturePathsAreAppendedToTheCustomServerUrl() {
        let context = TowerSignalContext.mockWith(site: .towersignal, serverUrl: "https://rum.example.com/")

        XCTAssertEqual(
            context.intakeEndpoint.appendingPathComponent("v1/ios/rum").absoluteString,
            "https://rum.example.com/v1/ios/rum"
        )
        XCTAssertEqual(
            context.intakeEndpoint.appendingPathComponent("v1/ios/logs").absoluteString,
            "https://rum.example.com/v1/ios/logs"
        )
        XCTAssertEqual(
            context.intakeEndpoint.appendingPathComponent("v1/ios/spans").absoluteString,
            "https://rum.example.com/v1/ios/spans"
        )
        XCTAssertEqual(
            context.intakeEndpoint.appendingPathComponent("v1/ios/replay").absoluteString,
            "https://rum.example.com/v1/ios/replay"
        )
    }
}

// MARK: - AgentInfo

class AgentInfoTests: XCTestCase {
    private let defaultName = AgentInfo.agentName
    private let defaultVersion = AgentInfo.agentVersion

    override func tearDown() {
        AgentInfo.agentName = defaultName
        AgentInfo.agentVersion = defaultVersion
        super.tearDown()
    }

    func testItIdentifiesTheNativeIOSAgentByDefault() {
        XCTAssertEqual(AgentInfo.agentName, "TowerSignal iOS Agent")
        XCTAssertEqual(AgentInfo.agentVersion, "1.0.0")
    }

    func testLogSourceIsNativeByDefault() {
        XCTAssertEqual(AgentInfo.logSource, "swift")
    }

    func testLogSourceFollowsTheCrossPlatformAgentName() {
        AgentInfo.agentName = "TowerSignal Flutter Agent"
        XCTAssertEqual(AgentInfo.logSource, "flutter")

        AgentInfo.agentName = "TowerSignal React Native Agent"
        XCTAssertEqual(AgentInfo.logSource, "react-native")
    }

    func testItAppendsTheAgentObjectAsASiblingOfTheEventProperties() throws {
        // Given
        struct Event: Encodable {
            let message: String
        }
        AgentInfo.agentName = "TowerSignal iOS Agent"
        AgentInfo.agentVersion = "2.3.4"

        // When
        let data = try JSONEncoder().encode(Event(message: "hello").withAgentInfo())

        // Then
        let json = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any])
        XCTAssertEqual(json["message"] as? String, "hello")
        let agent = try XCTUnwrap(json["agent"] as? [String: Any])
        XCTAssertEqual(agent["name"] as? String, "TowerSignal iOS Agent")
        XCTAssertEqual(agent["version"] as? String, "2.3.4")
        XCTAssertNil(json["log_source"], "log_source is only added when explicitly requested")
    }

    func testItAppendsLogSourceWhenRequested() throws {
        // Given
        struct Event: Encodable {
            let message: String
        }

        // When
        let data = try JSONEncoder().encode(Event(message: "hello").withAgentInfo(logSource: "swift"))

        // Then
        let json = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any])
        XCTAssertEqual(json["log_source"] as? String, "swift")
    }
}

// MARK: - URLRequestBuilder

class TowerSignalURLRequestBuilderTests: XCTestCase {
    func testItUsesTheTowerSignalIntakeHeaderNames() {
        XCTAssertEqual(URLRequestBuilder.HTTPHeader.atAPIKeyHeaderField, "api-key")
        XCTAssertEqual(URLRequestBuilder.HTTPHeader.atClientTokenHeaderField, "towersignal-client-token")
        XCTAssertEqual(URLRequestBuilder.HTTPHeader.atEVPOriginHeaderField, "TOWERSIGNAL-EVP-ORIGIN")
        XCTAssertEqual(URLRequestBuilder.HTTPHeader.atEVPOriginVersionHeaderField, "TOWERSIGNAL-EVP-ORIGIN-VERSION")
        XCTAssertEqual(URLRequestBuilder.HTTPHeader.atRequestIDHeaderField, "TOWERSIGNAL-REQUEST-ID")
        XCTAssertEqual(URLRequestBuilder.HTTPHeader.atIdempotencyKeyHeaderField, "AT-IDEMPOTENCY-KEY")
    }

    func testItDefinesTheAgentIdentificationHeaders() {
        XCTAssertEqual(URLRequestBuilder.HTTPHeader.towersignalAgentNameHeaderField, "TOWERSIGNAL-AGENT-NAME")
        XCTAssertEqual(URLRequestBuilder.HTTPHeader.towersignalAgentVersionHeaderField, "TOWERSIGNAL-AGENT-VERSION")
        XCTAssertEqual(URLRequestBuilder.HTTPHeader.towersignalAppNameHeaderField, "TOWERSIGNAL-APP-NAME")
    }

    func testItEncodesTheTowerSignalQueryParameterNames() throws {
        // Given
        let builder = URLRequestBuilder(
            // swiftlint:disable:next force_unwrapping
            url: URL(string: "https://mo-rx.towersignal.com/v1/ios/rum")!,
            queryItems: [
                .towersignalSource(source: "ios"),
                .towersignalTags(tags: ["retry_count:1"]),
                .licenseKey(licenseKey: "license-abc"),
                .agentName(agentName: "TowerSignal iOS Agent"),
                .agentVersion(agentVersion: "1.0.0"),
                .appName(appName: "MyApp")
            ],
            headers: []
        )

        // When
        let request = builder.uploadRequest(with: Data(), compress: false)

        // Then
        let components = try XCTUnwrap(URLComponents(url: try XCTUnwrap(request.url), resolvingAgainstBaseURL: false))
        let query = (components.queryItems ?? []).reduce(into: [String: String]()) { $0[$1.name] = $1.value }
        XCTAssertEqual(query["towersignal_source"], "ios")
        XCTAssertEqual(query["towersignaltags"], "retry_count:1")
        XCTAssertEqual(query["license_key"], "license-abc")
        XCTAssertEqual(query["agent_name"], "TowerSignal iOS Agent")
        XCTAssertEqual(query["agent_version"], "1.0.0")
        XCTAssertEqual(query["app_name"], "MyApp")
        XCTAssertNil(query["ddsource"])
        XCTAssertNil(query["ddtags"])
    }
}

// MARK: - Heartbeat

class AgentHeartbeatTests: XCTestCase {
    // swiftlint:disable:next force_unwrapping
    private let endpoint = URL(string: "https://mo-rx.towersignal.com")!

    private func configuration(licenseKey: String = "license-abc") -> HeartbeatConfiguration {
        HeartbeatConfiguration(
            endpoint: endpoint,
            licenseKey: licenseKey,
            appName: "MyApp",
            source: "ios"
        )
    }

    func testItBuildsTheAgentHeartbeatURL() throws {
        // When
        let url = try XCTUnwrap(
            AgentHeartbeat.heartbeatURL(path: AgentHeartbeat.agentHeartbeatPath, configuration: configuration())
        )

        // Then
        let components = try XCTUnwrap(URLComponents(url: url, resolvingAgainstBaseURL: false))
        XCTAssertEqual(components.path, "/v1/android/agent-heartbeat")
        let query = (components.queryItems ?? []).reduce(into: [String: String]()) { $0[$1.name] = $1.value }
        XCTAssertEqual(query["towersignal_source"], "ios")
        XCTAssertEqual(query["license_key"], "license-abc")
        XCTAssertEqual(query["agent_name"], AgentInfo.agentName)
        XCTAssertEqual(query["agent_version"], AgentInfo.agentVersion)
        XCTAssertEqual(query["app_name"], "MyApp")
    }

    func testItBuildsTheLogsHeartbeatURL() throws {
        // When
        let url = try XCTUnwrap(
            AgentHeartbeat.heartbeatURL(path: AgentHeartbeat.logsHeartbeatPath, configuration: configuration())
        )

        // Then
        XCTAssertEqual(URLComponents(url: url, resolvingAgainstBaseURL: false)?.path, "/v1/android/log/heart-beat")
    }

    func testItSkipsTheHeartbeatWhenTheLicenseKeyIsBlank() {
        // Given
        let completed = expectation(description: "completed")
        var capturedResult: Bool?

        // When
        AgentHeartbeat.check(
            path: AgentHeartbeat.agentHeartbeatPath,
            configuration: configuration(licenseKey: "")
        ) { allowed in
            capturedResult = allowed
            completed.fulfill()
        }

        // Then
        waitForExpectations(timeout: 1)
        XCTAssertEqual(capturedResult, false, "A blank license key must not produce a request")
    }

    func testLogsAreHeldBackUntilTheFirstHeartbeatAllowsThem() {
        // The Android agent defaults `LogsHeartbeatScheduler.isLogsAllowed` to `false`, so log
        // batches are skipped until the backend answers `allowAgent: true`.
        XCTAssertFalse(LogsHeartbeatScheduler.isLogsAllowed)
    }
}
// ATCHG: End
