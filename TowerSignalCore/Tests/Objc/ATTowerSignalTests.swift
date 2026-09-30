/*
* Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
* This product includes software developed at TowerSignal (https://www.towersignal.com/).
* Copyright 2026-Present TowerSignal, Inc.
*/

// ATCHG: TowerSignal SDK migration - renamed module imports `ddCore` -> `TowerSignalCore`, `ddInternal` ->
// `TowerSignalInternal`, `ddLogs` -> `TowerSignalLogs`; renamed the `DD` symbol prefix to `AT`; renamed
// `clientToken` to `licenseKey`; rebranded the `dd` name to `TowerSignal` in comments and docs; rebranded
// the licence header.

import XCTest
import TestUtilities

@testable import TowerSignalInternal
@testable import TowerSignalLogs
@_spi(objc)
@testable import TowerSignalCore

/// These tests verify that Objc APIs properly interact with`TowerSignal` public API (swift).
class ATTowerSignalTests: XCTestCase {
    override func setUp() {
        super.setUp()
        XCTAssertFalse(TowerSignal.isInitialized())
    }

    override func tearDown() {
        XCTAssertFalse(TowerSignal.isInitialized())
        super.tearDown()
    }

    // MARK: - SDK initialization / stop lifecycle

    func testItForwardsInitializationToSwift() throws {
        let config = objc_Configuration(
            licenseKey: "abcefghi",
            env: "tests"
        )

        config.bundle = .mockWith(CFBundleExecutable: "app-name")

        objc_TowerSignal.initialize(
            configuration: config,
            trackingConsent: randomConsent().objc
        )

        XCTAssertTrue(TowerSignal.isInitialized())

        let context = try XCTUnwrap(CoreRegistry.default as? TowerSignalCore).contextProvider.read()
        XCTAssertEqual(context.applicationName, "app-name")
        XCTAssertEqual(context.env, "tests")

        TowerSignal.flushAndDeinitialize()

        XCTAssertNil(CoreRegistry.default.get(feature: LogsFeature.self))
    }

    func testItReflectsInitializationStatus() throws {
        let config = objc_Configuration(
            licenseKey: "abcefghi",
            env: "tests"
        )

        config.bundle = .mockWith(CFBundleExecutable: "app-name")
        XCTAssertFalse(objc_TowerSignal.isInitialized())

        objc_TowerSignal.initialize(
            configuration: config,
            trackingConsent: randomConsent().objc
        )

        XCTAssertTrue(objc_TowerSignal.isInitialized())

        TowerSignal.flushAndDeinitialize()

        XCTAssertNil(CoreRegistry.default.get(feature: LogsFeature.self))
    }

    func testItForwardsStopInstanceToSwift() throws {
        let config = objc_Configuration(
            licenseKey: "abcefghi",
            env: "tests"
        )

        config.bundle = .mockWith(CFBundleExecutable: "app-name")

        objc_TowerSignal.initialize(
            configuration: config,
            trackingConsent: randomConsent().objc
        )

        XCTAssertTrue(TowerSignal.isInitialized())

        objc_TowerSignal.stopInstance()

        XCTAssertFalse(TowerSignal.isInitialized())

        XCTAssertNil(CoreRegistry.default.get(feature: LogsFeature.self))
    }

    // MARK: - Changing Tracking Consent

    func testItForwardsTrackingConsentToSwift() {
        let initialConsent = randomConsent()
        let nextConsent = randomConsent()

        objc_TowerSignal.initialize(
            configuration: objc_Configuration(licenseKey: "abcefghi", env: "tests"),
            trackingConsent: initialConsent.objc
        )

        let core = CoreRegistry.default as? TowerSignalCore
        XCTAssertEqual(core?.consentPublisher.consent, initialConsent.swift)

        objc_TowerSignal.setTrackingConsent(consent: nextConsent.objc)

        XCTAssertEqual(core?.consentPublisher.consent, nextConsent.swift)

        TowerSignal.flushAndDeinitialize()
    }

    // MARK: - Setting user info

    func testItForwardsUserInfoToSwift() throws {
        objc_TowerSignal.initialize(
            configuration: objc_Configuration(licenseKey: "abcefghi", env: "tests"),
            trackingConsent: randomConsent().objc
        )

        let core = CoreRegistry.default as? TowerSignalCore
        let userInfo = try XCTUnwrap(core?.userInfoPublisher)

        objc_TowerSignal.setUserInfo(
            userId: "id",
            name: "name",
            email: "email",
            extraInfo: [
                "attribute-int": 42,
                "attribute-double": 42.5,
                "attribute-string": "string value"
            ]
        )
        objc_TowerSignal.addUserExtraInfo(["foo": "bar"])
        XCTAssertEqual(userInfo.current.id, "id")
        XCTAssertEqual(userInfo.current.name, "name")
        XCTAssertEqual(userInfo.current.email, "email")
        let extraInfo = userInfo.current.extraInfo
        XCTAssertEqual(extraInfo["attribute-int"]?.dd.decode(), 42)
        XCTAssertEqual(extraInfo["attribute-double"]?.dd.decode(), 42.5)
        XCTAssertEqual(extraInfo["attribute-string"]?.dd.decode(), "string value")
        XCTAssertEqual(extraInfo["foo"]?.dd.decode(), "bar")

        objc_TowerSignal.setUserInfo(userId: "id", name: nil, email: nil, extraInfo: [:])
        XCTAssertNotNil(userInfo.current.id)
        XCTAssertNil(userInfo.current.name)
        XCTAssertNil(userInfo.current.email)
        XCTAssertTrue(userInfo.current.extraInfo.isEmpty)

        TowerSignal.flushAndDeinitialize()
    }

    // MARK: - Changing SDK verbosity level

    private let swiftVerbosityLevels: [CoreLoggerLevel?] = [
        .debug, .warn, .error, .critical, nil
    ]
    private let objcVerbosityLevels: [objc_CoreLoggerLevel] = [
        .debug, .warn, .error, .critical, .none
    ]

    func testItForwardsSettingVerbosityLevelToSwift() {
        defer { TowerSignal.verbosityLevel = nil }

        zip(swiftVerbosityLevels, objcVerbosityLevels).forEach { swiftLevel, objcLevel in
            objc_TowerSignal.setVerbosityLevel(objcLevel)
            XCTAssertEqual(TowerSignal.verbosityLevel, swiftLevel)
        }
    }

    func testItGetsVerbosityLevelFromSwift() {
        defer { TowerSignal.verbosityLevel = nil }

        zip(swiftVerbosityLevels, objcVerbosityLevels).forEach { swiftLevel, objcLevel in
            TowerSignal.verbosityLevel = swiftLevel
            XCTAssertEqual(objc_TowerSignal.verbosityLevel(), objcLevel)
        }
    }

    // MARK: - Helpers

    private func randomConsent() -> (objc: objc_TrackingConsent, swift: TrackingConsent) {
        let objcConsents: [objc_TrackingConsent] = [.granted(), .notGranted(), .pending()]
        let swiftConsents: [TrackingConsent] = [.granted, .notGranted, .pending]
        let index: Int = .random(in: 0..<3)
        return (objc: objcConsents[index], swift: swiftConsents[index])
    }
}
