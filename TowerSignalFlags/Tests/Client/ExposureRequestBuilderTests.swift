/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddFlags` -> `TowerSignalFlags`, `ddInternal`
// -> `TowerSignalInternal`; renamed `dd*` types to `TowerSignal*`; renamed the `DD` symbol prefix to `AT`;
// renamed `clientToken` to `licenseKey`; renamed the `ddsource` / `ddtags` query parameters to
// `towersignal_source` / `towersignaltags`; renamed the `DD-*` intake headers to their TowerSignal equivalents; repointed
// the intake host at the TowerSignal site; rebranded the licence header.

import XCTest
import TestUtilities
import TowerSignalInternal

@testable import TowerSignalFlags

final class ExposureRequestBuilderTests: XCTestCase {
    private let mockEvents: [Event] = [
        .init(data: "event 1".utf8Data),
        .init(data: "event 2".utf8Data),
        .init(data: "event 3".utf8Data)
    ]

    func testItCreatesPOSTRequest() throws {
        // Given
        let builder = ExposureRequestBuilder(
            customIntakeURL: nil,
            telemetry: NOPTelemetry()
        )

        // When
        let request = try builder.request(for: mockEvents, with: .mockAny(), execution: .mockAny())

        // Then
        XCTAssertEqual(request.httpMethod, "POST")
    }

    func testItSetsExposuresIntakeURL() {
        // Given
        let builder = ExposureRequestBuilder(
            customIntakeURL: nil,
            telemetry: NOPTelemetry()
        )

        // When
        func url(for site: TowerSignalSite) -> String {
            let request = try! builder.request(for: mockEvents, with: .mockWith(site: site), execution: .mockAny())
            return request.url!.absoluteStringWithoutQuery!
        }

        // Then
        // ATCHG: single TowerSignal intake host replaces the nine dd region endpoints
        XCTAssertEqual(url(for: .towersignal), "https://mo-rx.towersignal.com/api/v2/exposures")
    }

    func testItSetsCustomIntakeURL() throws {
        // Given
        let randomURL: URL = .mockRandom()
        let builder = ExposureRequestBuilder(
            customIntakeURL: randomURL,
            telemetry: NOPTelemetry()
        )

        // When
        func url(for site: TowerSignalSite) -> String {
            let request = try! builder.request(for: mockEvents, with: .mockWith(site: site), execution: .mockAny())
            return request.url!.absoluteStringWithoutQuery!
        }

        // Then
        let expectedURL = randomURL.absoluteStringWithoutQuery
        // ATCHG: single TowerSignal site replaces the nine dd regions
        XCTAssertEqual(url(for: .towersignal), expectedURL)
    }

    func testItSetsExposureQueryParameters() throws {
        let randomSource: String = .mockRandom(among: .alphanumerics)

        // Given
        let builder = ExposureRequestBuilder(
            customIntakeURL: nil,
            telemetry: NOPTelemetry()
        )
        let context: TowerSignalContext = .mockWith(source: randomSource)

        // When
        let request = try builder.request(for: mockEvents, with: context, execution: .mockAny())

        // Then
        let expectedQuery = "towersignal_source=\(randomSource)"
        XCTAssertEqual(request.url?.query, expectedQuery)
    }

    func testItSetsExposureHTTPHeaders() throws {
        let randomApplicationName: String = .mockRandom(among: .alphanumerics)
        let randomVersion: String = .mockRandom(among: .decimalDigits)
        let randomSource: String = .mockRandom(among: .alphanumerics)
        let randomOrigin: String = .mockRandom(among: .alphanumerics)
        let randomSDKVersion: String = .mockRandom(among: .alphanumerics)
        let randomClientToken: String = .mockRandom()
        let randomDeviceName: String = .mockRandom()
        let randomDeviceOSName: String = .mockRandom()
        let randomDeviceOSVersion: String = .mockRandom()

        // Given
        let builder = ExposureRequestBuilder(
            customIntakeURL: nil,
            telemetry: NOPTelemetry()
        )
        let context: TowerSignalContext = .mockWith(
            licenseKey: randomClientToken,
            version: randomVersion,
            source: randomSource,
            sdkVersion: randomSDKVersion,
            ciAppOrigin: randomOrigin,
            applicationName: randomApplicationName,
            device: .mockWith(name: randomDeviceName),
            os: .mockWith(
                name: randomDeviceOSName,
                version: randomDeviceOSVersion
            )
        )

        // When
        let request = try builder.request(for: mockEvents, with: context, execution: .mockAny())

        // Then
        XCTAssertEqual(
            request.allHTTPHeaderFields?["User-Agent"],
            """
            \(randomApplicationName)/\(randomVersion) CFNetwork (\(randomDeviceName); \(randomDeviceOSName)/\(randomDeviceOSVersion))
            """
        )
        XCTAssertEqual(request.allHTTPHeaderFields?["Content-Type"], "text/plain;charset=UTF-8")
        XCTAssertEqual(request.allHTTPHeaderFields?["api-key"], randomClientToken)
        XCTAssertEqual(request.allHTTPHeaderFields?["TOWERSIGNAL-EVP-ORIGIN"], randomOrigin)
        XCTAssertEqual(request.allHTTPHeaderFields?["TOWERSIGNAL-EVP-ORIGIN-VERSION"], randomSDKVersion)
        XCTAssertEqual(request.allHTTPHeaderFields?["TOWERSIGNAL-REQUEST-ID"]?.matches(regex: .uuidRegex), true)
    }

    func testItSetsHTTPBodyInExpectedFormat() throws {
        // Given
        let builder = ExposureRequestBuilder(
            customIntakeURL: nil,
            telemetry: NOPTelemetry()
        )

        // When
        let request = try builder.request(for: mockEvents, with: .mockAny(), execution: .mockAny())

        // Then
        let httpBodyData = try XCTUnwrap(request.httpBody)
        let actual = String(data: httpBodyData, encoding: .utf8)
        let expected = """
        event 1
        event 2
        event 3
        """
        XCTAssertEqual(expected, actual, "It must separate each event with newline character")
    }
}
