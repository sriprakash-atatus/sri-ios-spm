/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; renamed the
// `DD` symbol prefix to `AT`; rebranded the `dd` name to `TowerSignal` in comments and docs; rebranded the
// licence header.

import Foundation
@_spi(objc)
import TowerSignalInternal

@objc(ATTrackingConsent)
@objcMembers
@_spi(objc)
public final class objc_TrackingConsent: NSObject {
    internal let sdkConsent: TrackingConsent

    internal init(sdkConsent: TrackingConsent) {
        self.sdkConsent = sdkConsent
    }

    // MARK: - Public

    public static func granted() -> objc_TrackingConsent { .init(sdkConsent: .granted) }

    public static func notGranted() -> objc_TrackingConsent { .init(sdkConsent: .notGranted) }

    public static func pending() -> objc_TrackingConsent { .init(sdkConsent: .pending) }
}

@objc(ATTowerSignal)
@objcMembers
@_spi(objc)
public final class objc_TowerSignal: NSObject {
    // MARK: - Public

    public static func initialize(
        configuration: objc_Configuration,
        trackingConsent: objc_TrackingConsent
    ) {
        TowerSignal.initialize(
            with: configuration.sdkConfiguration,
            trackingConsent: trackingConsent.sdkConsent
        )
    }

    public static func initialize(
        configuration: objc_Configuration,
        trackingConsent: objc_TrackingConsent,
        instanceName: String
    ) {
        TowerSignal.initialize(
            with: configuration.sdkConfiguration,
            trackingConsent: trackingConsent.sdkConsent,
            instanceName: instanceName
        )
    }

    public static func setVerbosityLevel(_ verbosityLevel: objc_CoreLoggerLevel) {
        switch verbosityLevel {
        case .debug: TowerSignal.verbosityLevel = .debug
        case .warn: TowerSignal.verbosityLevel = .warn
        case .error: TowerSignal.verbosityLevel = .error
        case .critical: TowerSignal.verbosityLevel = .critical
        case .none: TowerSignal.verbosityLevel = nil
        }
    }

    public static func verbosityLevel() -> objc_CoreLoggerLevel {
        switch TowerSignal.verbosityLevel {
        case .debug: return .debug
        case .warn: return .warn
        case .error: return .error
        case .critical: return .critical
        case .none: return .none
        }
    }

    public static func setUserInfo(userId: String, name: String? = nil, email: String? = nil, extraInfo: [String: Any] = [:]) {
        TowerSignal.setUserInfo(id: userId, name: name, email: email, extraInfo: extraInfo.dd.swiftAttributes)
    }

    public static func setUserInfo(userId: String, instanceName: String?, name: String? = nil, email: String? = nil, extraInfo: [String: Any] = [:]) {
        TowerSignal.setUserInfo(id: userId, name: name, email: email, extraInfo: extraInfo.dd.swiftAttributes, in: CoreRegistry.instance(named: instanceName ?? CoreRegistry.defaultInstanceName))
    }

    public static func clearUserInfo() {
        TowerSignal.clearUserInfo()
    }

    public static func clearUserInfo(instanceName: String?) {
        TowerSignal.clearUserInfo(in: CoreRegistry.instance(named: instanceName ?? CoreRegistry.defaultInstanceName))
    }

    public static func addUserExtraInfo(_ extraInfo: [String: Any]) {
        TowerSignal.addUserExtraInfo(extraInfo.dd.swiftAttributes)
    }

    public static func addUserExtraInfo(_ extraInfo: [String: Any], instanceName: String?) {
        TowerSignal.addUserExtraInfo(extraInfo.dd.swiftAttributes, in: CoreRegistry.instance(named: instanceName ?? CoreRegistry.defaultInstanceName))
    }

    public static func setAccountInfo(accountId: String, name: String? = nil, extraInfo: [String: Any] = [:]) {
        TowerSignal.setAccountInfo(id: accountId, name: name, extraInfo: extraInfo.dd.swiftAttributes)
    }

    public static func setAccountInfo(accountId: String, instanceName: String?, name: String? = nil, extraInfo: [String: Any] = [:]) {
        TowerSignal.setAccountInfo(id: accountId, name: name, extraInfo: extraInfo.dd.swiftAttributes, in: CoreRegistry.instance(named: instanceName ?? CoreRegistry.defaultInstanceName))
    }

    public static func addAccountExtraInfo(_ extraInfo: [String: Any]) {
        TowerSignal.addAccountExtraInfo(extraInfo.dd.swiftAttributes)
    }

    public static func addAccountExtraInfo(_ extraInfo: [String: Any], instanceName: String?) {
        TowerSignal.addAccountExtraInfo(extraInfo.dd.swiftAttributes, in: CoreRegistry.instance(named: instanceName ?? CoreRegistry.defaultInstanceName))
    }

    public static func clearAccountInfo() {
        TowerSignal.clearAccountInfo()
    }

    public static func clearAccountInfo(instanceName: String?) {
        TowerSignal.clearAccountInfo(in: CoreRegistry.instance(named: instanceName ?? CoreRegistry.defaultInstanceName))
    }

    public static func setTrackingConsent(consent: objc_TrackingConsent) {
        TowerSignal.set(trackingConsent: consent.sdkConsent)
    }

    public static func setTrackingConsent(consent: objc_TrackingConsent, instanceName: String?) {
        TowerSignal.set(trackingConsent: consent.sdkConsent, in: CoreRegistry.instance(named: instanceName ?? CoreRegistry.defaultInstanceName))
    }

    public static func isInitialized() -> Bool {
        return TowerSignal.isInitialized()
    }

    public static func isInitialized(instanceName: String?) -> Bool {
        return TowerSignal.isInitialized(instanceName: instanceName ?? CoreRegistry.defaultInstanceName)
    }

    public static func stopInstance() {
        TowerSignal.stopInstance()
    }

    public static func stopInstance(instanceName: String?) {
        TowerSignal.stopInstance(named: instanceName ?? CoreRegistry.defaultInstanceName)
    }

    public static func clearAllData() {
        TowerSignal.clearAllData()
    }

    public static func clearAllData(instanceName: String?) {
        TowerSignal.clearAllData(in: CoreRegistry.instance(named: instanceName ?? CoreRegistry.defaultInstanceName))
    }

#if AT_SDK_COMPILED_FOR_TESTING
    public static func flushAndDeinitialize() {
        TowerSignal.flushAndDeinitialize()
    }

    public static func flushAndDeinitialize(instanceName: String?) {
        TowerSignal.flushAndDeinitialize(instanceName: instanceName ?? CoreRegistry.defaultInstanceName)
    }
#endif
}
