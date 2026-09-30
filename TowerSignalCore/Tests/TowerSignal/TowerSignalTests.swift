/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddCore` -> `TowerSignalCore`, `ddInternal` ->
// `TowerSignalInternal`, `ddLogs` -> `TowerSignalLogs`, `ddTrace` -> `TowerSignalTrace`; renamed `dd*`
// types to `TowerSignal*`; renamed `clientToken` to `licenseKey`; renamed the build `variant` to `appName`;
// renamed the `ddsource` / `ddtags` query parameters to `towersignal_source` / `towersignaltags`; renamed
// `com.ddhq.*` identifiers to `com.towersignal.*`; rebranded the `dd` name to `TowerSignal` in comments and
// docs; rebranded the licence header.

import XCTest
import TestUtilities

@testable import TowerSignalInternal
@testable import TowerSignalLogs
@testable import TowerSignalTrace
@testable import TowerSignalCore

class TowerSignalTests: XCTestCase {
    private var printFunction: PrintFunctionSpy! // swiftlint:disable:this implicitly_unwrapped_optional
    private var defaultConfig = TowerSignal.Configuration(licenseKey: "abc-123", env: "tests")

    override func setUp() {
        super.setUp()

        XCTAssertFalse(TowerSignal.isInitialized())
        printFunction = PrintFunctionSpy()
        consolePrint = printFunction.print
    }

    override func tearDown() {
        consolePrint = { message, _ in print(message) }
        printFunction = nil
        XCTAssertFalse(TowerSignal.isInitialized())
        super.tearDown()
    }

    // MARK: - Initializing with different configurations

    func testDefaultConfiguration() throws {
        var configuration = defaultConfig

        configuration.bundle = .mockWith(
            bundleIdentifier: "test",
            CFBundleShortVersionString: "1.0.0",
            CFBundleExecutable: "Test"
        )

        XCTAssertEqual(configuration.batchSize, .medium)
        XCTAssertEqual(configuration.uploadFrequency, .average)
        XCTAssertEqual(configuration.additionalConfiguration.count, 0)
        XCTAssertNil(configuration.encryption)
        XCTAssertTrue(configuration.serverDateProvider is TowerSignalNTPDateProvider)

        TowerSignal.initialize(
            with: configuration,
            trackingConsent: .granted
        )
        defer { TowerSignal.flushAndDeinitialize() }

        let core = try XCTUnwrap(CoreRegistry.default as? TowerSignalCore)
        let urlSessionClient = try XCTUnwrap(core.httpClient as? URLSessionClient)
        XCTAssertTrue(core.dateProvider is SystemDateProvider)
        XCTAssertNil(urlSessionClient.session.configuration.connectionProxyDictionary)
        XCTAssertNil(core.encryption)

        let context = core.contextProvider.read()
        XCTAssertEqual(context.licenseKey, "abc-123")
        XCTAssertEqual(context.env, "tests")
        XCTAssertEqual(context.site, .towersignal)
        XCTAssertEqual(context.service, "test")
        XCTAssertEqual(context.version, "1.0.0")
        XCTAssertEqual(context.sdkVersion, __sdkVersion)
        XCTAssertEqual(context.applicationName, "Test")
        XCTAssertNil(context.appName)
        XCTAssertEqual(context.source, "ios")
        XCTAssertEqual(context.applicationBundleIdentifier, "test")
        XCTAssertEqual(context.trackingConsent, .granted)
    }

    func testAdvancedConfiguration() throws {
        var configuration = defaultConfig

        configuration.service = "service-name"
        configuration.site = .towersignal
        configuration.batchSize = .small
        configuration.uploadFrequency = .frequent
        #if !os(watchOS)
        configuration.proxyConfiguration = [
            kCFNetworkProxiesHTTPEnable: true,
            kCFNetworkProxiesHTTPPort: 123,
            kCFNetworkProxiesHTTPProxy: "www.example.com",
            kCFProxyUsernameKey: "proxyuser",
            kCFProxyPasswordKey: "proxypass",
        ]
        #endif
        configuration.bundle = .mockWith(
            bundleIdentifier: "test",
            CFBundleShortVersionString: "1.0.0",
            CFBundleExecutable: "Test"
        )
        configuration.encryption = DataEncryptionMock()
        configuration.serverDateProvider = ServerDateProviderMock()
        configuration._internal_mutation {
            $0.additionalConfiguration = [
                CrossPlatformAttributes.towersignalSource: "cp-source",
                CrossPlatformAttributes.appName: "cp-appName",
                CrossPlatformAttributes.sdkVersion: "cp-version"
            ]
        }

        XCTAssertEqual(configuration.batchSize, .small)
        XCTAssertEqual(configuration.uploadFrequency, .frequent)
        XCTAssertTrue(configuration.encryption is DataEncryptionMock)
        XCTAssertTrue(configuration.serverDateProvider is ServerDateProviderMock)

        TowerSignal.initialize(
            with: configuration,
            trackingConsent: .pending
        )
        defer { TowerSignal.flushAndDeinitialize() }

        let core = try XCTUnwrap(CoreRegistry.default as? TowerSignalCore)
        XCTAssertTrue(core.dateProvider is SystemDateProvider)
        XCTAssertTrue(core.encryption is DataEncryptionMock)

        #if !os(watchOS)
        let urlSessionClient = try XCTUnwrap(core.httpClient as? URLSessionClient)
        let connectionProxyDictionary = try XCTUnwrap(urlSessionClient.session.configuration.connectionProxyDictionary)
        XCTAssertEqual(connectionProxyDictionary[kCFNetworkProxiesHTTPEnable] as? Bool, true)
        XCTAssertEqual(connectionProxyDictionary[kCFNetworkProxiesHTTPPort] as? Int, 123)
        XCTAssertEqual(connectionProxyDictionary[kCFNetworkProxiesHTTPProxy] as? String, "www.example.com")
        XCTAssertEqual(connectionProxyDictionary[kCFProxyUsernameKey] as? String, "proxyuser")
        XCTAssertEqual(connectionProxyDictionary[kCFProxyPasswordKey] as? String, "proxypass")
        #endif

        let context = core.contextProvider.read()
        XCTAssertEqual(context.licenseKey, "abc-123")
        XCTAssertEqual(context.env, "tests")
        XCTAssertEqual(context.site, .towersignal)
        XCTAssertEqual(context.service, "service-name")
        XCTAssertEqual(context.version, "1.0.0")
        XCTAssertEqual(context.sdkVersion, "cp-version")
        XCTAssertEqual(context.applicationName, "Test")
        XCTAssertEqual(context.appName, "cp-appName")
        XCTAssertEqual(context.source, "cp-source")
        XCTAssertEqual(context.applicationBundleIdentifier, "test")
        XCTAssertEqual(context.trackingConsent, .pending)
    }

    func testGivenDefaultConfiguration_itCanBeInitialized() {
        TowerSignal.initialize(
            with: defaultConfig,
            trackingConsent: .mockRandom()
        )
        XCTAssertTrue(TowerSignal.isInitialized())
        TowerSignal.flushAndDeinitialize()
    }

    func testGivenInvalidConfiguration_itPrintsError() {
        let invalidConfiguration = TowerSignal.Configuration(licenseKey: "", env: "tests")

        TowerSignal.initialize(
            with: invalidConfiguration,
            trackingConsent: .mockRandom()
        )

        XCTAssertEqual(
            printFunction.printedMessage,
            "🔥 TowerSignal SDK usage error: `licenseKey` cannot be empty."
        )
        XCTAssertFalse(TowerSignal.isInitialized())
    }

    func testGivenValidConfiguration_whenInitializedMoreThanOnce_itPrintsError() {
        TowerSignal.initialize(
            with: defaultConfig,
            trackingConsent: .mockRandom()
        )

        TowerSignal.initialize(
            with: defaultConfig,
            trackingConsent: .mockRandom()
        )

        XCTAssertEqual(
            printFunction.printedMessage,
            "🔥 TowerSignal SDK usage error: The 'main' instance of SDK is already initialized."
        )

        TowerSignal.flushAndDeinitialize()
    }

    // MARK: - Public APIs

    func testTrackingConsent() {
        let initialConsent: TrackingConsent = .mockRandom()
        let nextConsent: TrackingConsent = .mockRandom()

        TowerSignal.initialize(
            with: defaultConfig,
            trackingConsent: initialConsent
        )

        let core = CoreRegistry.default as? TowerSignalCore
        XCTAssertEqual(core?.consentPublisher.consent, initialConsent)

        TowerSignal.set(trackingConsent: nextConsent)

        XCTAssertEqual(core?.consentPublisher.consent, nextConsent)

        TowerSignal.flushAndDeinitialize()
    }

    func testUserInfo() {
        TowerSignal.initialize(
            with: defaultConfig,
            trackingConsent: .mockRandom()
        )

        let core = CoreRegistry.default as? TowerSignalCore

        XCTAssertNil(core?.userInfoPublisher.current.id)
        XCTAssertNil(core?.userInfoPublisher.current.email)
        XCTAssertNil(core?.userInfoPublisher.current.name)
        XCTAssertEqual(core?.userInfoPublisher.current.extraInfo as? [String: Int], [:])

        TowerSignal.setUserInfo(
            id: "foo",
            name: "bar",
            email: "foo@bar.com",
            extraInfo: ["abc": 123]
        )
        core?.set(anonymousId: "anonymous-id")

        XCTAssertEqual(core?.userInfoPublisher.current.anonymousId, "anonymous-id")
        XCTAssertEqual(core?.userInfoPublisher.current.id, "foo")
        XCTAssertEqual(core?.userInfoPublisher.current.name, "bar")
        XCTAssertEqual(core?.userInfoPublisher.current.email, "foo@bar.com")
        XCTAssertEqual(core?.userInfoPublisher.current.extraInfo as? [String: Int], ["abc": 123])

        TowerSignal.clearUserInfo()

        XCTAssertEqual(core?.userInfoPublisher.current.anonymousId, "anonymous-id")
        XCTAssertNil(core?.userInfoPublisher.current.id)
        XCTAssertNil(core?.userInfoPublisher.current.email)
        XCTAssertNil(core?.userInfoPublisher.current.name)
        XCTAssertEqual(core?.userInfoPublisher.current.extraInfo as? [String: Int], [:])

        TowerSignal.flushAndDeinitialize()
    }

    func testAddUserProperties_mergesProperties() {
        TowerSignal.initialize(
            with: defaultConfig,
            trackingConsent: .mockRandom()
        )

        let core = CoreRegistry.default as? TowerSignalCore

        TowerSignal.setUserInfo(
            id: "foo",
            name: "bar",
            email: "foo@bar.com",
            extraInfo: ["abc": 123]
        )

        TowerSignal.addUserExtraInfo(["second": 667])

        XCTAssertEqual(core?.userInfoPublisher.current.id, "foo")
        XCTAssertEqual(core?.userInfoPublisher.current.name, "bar")
        XCTAssertEqual(core?.userInfoPublisher.current.email, "foo@bar.com")
        XCTAssertEqual(
            core?.userInfoPublisher.current.extraInfo as? [String: Int],
            ["abc": 123, "second": 667]
        )

        TowerSignal.flushAndDeinitialize()
    }

    func testAddUserProperties_removesProperties() {
        TowerSignal.initialize(
            with: defaultConfig,
            trackingConsent: .mockRandom()
        )

        let core = CoreRegistry.default as? TowerSignalCore

        TowerSignal.setUserInfo(
            id: "foo",
            name: "bar",
            email: "foo@bar.com",
            extraInfo: ["abc": 123]
        )

        TowerSignal.addUserExtraInfo(["abc": nil, "second": 667])

        XCTAssertEqual(core?.userInfoPublisher.current.id, "foo")
        XCTAssertEqual(core?.userInfoPublisher.current.name, "bar")
        XCTAssertEqual(core?.userInfoPublisher.current.email, "foo@bar.com")
        XCTAssertEqual(core?.userInfoPublisher.current.extraInfo as? [String: Int], ["second": 667])

        TowerSignal.flushAndDeinitialize()
    }

    func testAddUserProperties_overwritesProperties() {
        TowerSignal.initialize(
            with: defaultConfig,
            trackingConsent: .mockRandom()
        )

        let core = CoreRegistry.default as? TowerSignalCore

        TowerSignal.setUserInfo(
            id: "foo",
            name: "bar",
            email: "foo@bar.com",
            extraInfo: ["abc": 123]
        )

        TowerSignal.addUserExtraInfo(["abc": 444])

        XCTAssertEqual(core?.userInfoPublisher.current.id, "foo")
        XCTAssertEqual(core?.userInfoPublisher.current.name, "bar")
        XCTAssertEqual(core?.userInfoPublisher.current.email, "foo@bar.com")
        XCTAssertEqual(core?.userInfoPublisher.current.extraInfo as? [String: Int], ["abc": 444])

        TowerSignal.flushAndDeinitialize()
    }

    func testAccountInfo() {
        TowerSignal.initialize(
            with: defaultConfig,
            trackingConsent: .mockRandom()
        )

        let core = CoreRegistry.default as? TowerSignalCore

        XCTAssertNil(core?.accountInfoPublisher.current)

        TowerSignal.setAccountInfo(
            id: "foo",
            name: "bar",
            extraInfo: ["abc": 123]
        )

        XCTAssertEqual(core?.accountInfoPublisher.current?.id, "foo")
        XCTAssertEqual(core?.accountInfoPublisher.current?.name, "bar")
        XCTAssertEqual(core?.accountInfoPublisher.current?.extraInfo as? [String: Int], ["abc": 123])

        TowerSignal.flushAndDeinitialize()
    }

    func testAddAccountProperties_mergesProperties() {
        TowerSignal.initialize(
            with: defaultConfig,
            trackingConsent: .mockRandom()
        )

        let core = CoreRegistry.default as? TowerSignalCore

        TowerSignal.setAccountInfo(
            id: "foo",
            name: "bar",
            extraInfo: ["abc": 123]
        )

        TowerSignal.addAccountExtraInfo(["second": 667])

        XCTAssertEqual(core?.accountInfoPublisher.current?.id, "foo")
        XCTAssertEqual(core?.accountInfoPublisher.current?.name, "bar")
        XCTAssertEqual(
            core?.accountInfoPublisher.current?.extraInfo as? [String: Int],
            ["abc": 123, "second": 667]
        )

        TowerSignal.flushAndDeinitialize()
    }

    func testAddAccountProperties_removesProperties() {
        TowerSignal.initialize(
            with: defaultConfig,
            trackingConsent: .mockRandom()
        )

        let core = CoreRegistry.default as? TowerSignalCore

        TowerSignal.setAccountInfo(
            id: "foo",
            name: "bar",
            extraInfo: ["abc": 123]
        )

        TowerSignal.addAccountExtraInfo(["abc": nil, "second": 667])

        XCTAssertEqual(core?.accountInfoPublisher.current?.id, "foo")
        XCTAssertEqual(core?.accountInfoPublisher.current?.name, "bar")
        XCTAssertEqual(core?.accountInfoPublisher.current?.extraInfo as? [String: Int], ["second": 667])

        TowerSignal.flushAndDeinitialize()
    }

    func testAddAccountProperties_overwritesProperties() {
        TowerSignal.initialize(
            with: defaultConfig,
            trackingConsent: .mockRandom()
        )

        let core = CoreRegistry.default as? TowerSignalCore

        TowerSignal.setAccountInfo(
            id: "foo",
            name: "bar",
            extraInfo: ["abc": 123]
        )

        TowerSignal.addAccountExtraInfo(["abc": 444])

        XCTAssertEqual(core?.accountInfoPublisher.current?.id, "foo")
        XCTAssertEqual(core?.accountInfoPublisher.current?.name, "bar")
        XCTAssertEqual(core?.accountInfoPublisher.current?.extraInfo as? [String: Int], ["abc": 444])

        TowerSignal.flushAndDeinitialize()
    }

    func testDefaultVerbosityLevel() {
        XCTAssertNil(TowerSignal.verbosityLevel)
    }

    func testGivenDataStoredInAllFeatureDirectories_whenClearAllDataIsUsed_allFilesAreRemoved() throws {
        TowerSignal.initialize(
            with: defaultConfig,
            trackingConsent: .mockRandom()
        )

        Logs.enable()
        Trace.enable()

        let core = try XCTUnwrap(CoreRegistry.default as? TowerSignalCore)

        // On SDK init, underlying `ConsentAwareDataWriter` performs data migration for each feature, which includes
        // data removal in `unauthorised` (`.pending`) directory. To not cause test flakiness, we must ensure that
        // mock data is written only after this operation completes - otherwise, migration may delete mocked files.
        core.readWriteQueue.sync {}

        // Given
        let featureDirectories: [FeatureDirectories] = [
            try core.directory.getFeatureDirectories(forFeatureNamed: "logging"),
            try core.directory.getFeatureDirectories(forFeatureNamed: "tracing"),
        ]

        let scope = core.scope(for: TraceFeature.self)
        scope.dataStore.setValue("foo".data(using: .utf8)!, forKey: "bar")

        // Wait for async clear completion in all features:
        core.readWriteQueue.sync {}
        let tracingDataStoreDir = try core.directory.coreDirectory.subdirectory(path: core.directory.getDataStorePath(forFeatureNamed: "tracing"))
        XCTAssertTrue(tracingDataStoreDir.hasFile(named: "bar"))

        var allDirectories: [Directory] = featureDirectories.flatMap { [$0.authorized, $0.unauthorized] }
        allDirectories.append(.init(url: tracingDataStoreDir.url))
        try allDirectories.forEach { directory in _ = try directory.createFile(named: .mockRandom()) }

        // When
        TowerSignal.clearAllData()

        // Wait for async clear completion in all features:
        core.readWriteQueue.sync {}

        // Then
        let files: [File] = allDirectories.reduce([], { acc, nextDirectory in
            let next = try? nextDirectory.files()
            return acc + (next ?? [])
        })
        XCTAssertEqual(files, [], "All files must be removed")

        TowerSignal.flushAndDeinitialize()
    }

    func testServerDateProvider() throws {
        // Given
        var config = defaultConfig
        let serverDateProvider = ServerDateProviderMock()
        config.serverDateProvider = serverDateProvider

        // When
        TowerSignal.initialize(
            with: config,
            trackingConsent: .mockRandom()
        )

        serverDateProvider.offset = -1

        // Then
        let core = try XCTUnwrap(CoreRegistry.default as? TowerSignalCore)
        let context = core.contextProvider.read()
        XCTAssertEqual(context.serverTimeOffset, -1)

        TowerSignal.flushAndDeinitialize()
    }

    func testRemoveV1DeprecatedFolders() throws {
        // Given
        let cache = try Directory.cache()
        let directories = ["com.towersignal.logs", "com.towersignal.traces", "com.towersignal.rum"]
        try directories.forEach {
            _ = try cache.createSubdirectory(path: $0).createFile(named: "test")
        }

        // When
        TowerSignal.initialize(
            with: defaultConfig,
            trackingConsent: .mockRandom()
        )

        defer { TowerSignal.flushAndDeinitialize() }

        let core = try XCTUnwrap(CoreRegistry.default as? TowerSignalCore)
        // Wait for async deletion
        core.readWriteQueue.sync {}

        // Then
        XCTAssertThrowsError(try cache.subdirectory(path: "com.towersignal.logs"))
        XCTAssertThrowsError(try cache.subdirectory(path: "com.towersignal.traces"))
        XCTAssertThrowsError(try cache.subdirectory(path: "com.towersignal.rum"))
    }

    func testCustomSDKInstance() throws {
        // When
        TowerSignal.initialize(
            with: defaultConfig,
            trackingConsent: .mockRandom(),
            instanceName: "test"
        )

        defer { TowerSignal.flushAndDeinitialize(instanceName: "test") }

        // Then
        XCTAssertTrue(CoreRegistry.default is NOPTowerSignalCore)
        XCTAssertTrue(CoreRegistry.instance(named: "test") is TowerSignalCore)
    }

    func testStopSDKInstance() throws {
        // Given
        TowerSignal.initialize(
            with: defaultConfig,
            trackingConsent: .mockRandom(),
            instanceName: "test"
        )

        // Then
        XCTAssertTrue(CoreRegistry.instance(named: "test") is TowerSignalCore)

        // When
        TowerSignal.stopInstance(named: "test")

        // Then
        XCTAssertTrue(CoreRegistry.instance(named: "test") is NOPTowerSignalCore)
    }

    func testGivenDefaultSDKInstanceInitialized_customOneCanBeInitializedAfterIt() throws {
        let defaultConfig = TowerSignal.Configuration(licenseKey: "abc-123", env: "default")
        let customConfig = TowerSignal.Configuration(licenseKey: "def-456", env: "custom")

        // Given
        TowerSignal.initialize(
            with: defaultConfig,
            trackingConsent: .mockRandom()
        )
        defer { TowerSignal.flushAndDeinitialize() }

        // When
        TowerSignal.initialize(
            with: customConfig,
            trackingConsent: .mockRandom(),
            instanceName: "custom-instance"
        )
        defer { TowerSignal.flushAndDeinitialize(instanceName: "custom-instance") }

        // Then
        XCTAssertTrue(CoreRegistry.default is TowerSignalCore)
        XCTAssertTrue(CoreRegistry.instance(named: "custom-instance") is TowerSignalCore)
    }
}
