/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddCore` -> `TowerSignalCore`, `ddInternal` ->
// `TowerSignalInternal`; renamed `dd*` types to `TowerSignal*`; renamed the `DD` symbol prefix to `AT`; renamed
// `clientToken` to `licenseKey`; rebranded the `dd` name to `TowerSignal` in comments and docs; rebranded
// the licence header.

import Foundation
import TowerSignalInternal
import TowerSignalCore

/// Test info reads configuration from `Info.plist`.
///
/// The expected format is as follow:
///
///     <dict>
///         <key>TowerSignalConfiguration</key>
///         <dict>
///             <key>LicenseKey</key>
///             <string>$(CLIENT_TOKEN)</string>
///             <key>ApplicationID</key>
///             <string>$(RUM_APPLICATION_ID)</string>
///             <key>Environment</key>
///             <string>$(AT_ENV)</string>
///             <key>Site</key>
///             <string>$(AT_SITE)</string>
///         </dict>
///     </dict>
struct TestInfo {
    let licenseKey: String
    let applicationID: String
    let site: TowerSignalSite
    let env: String
}

extension TestInfo {
    init(bundle: Bundle = .main) throws {
        guard
            let obj = bundle.object(forInfoDictionaryKey: "TowerSignalConfiguration") as? [String: String],
            let licenseKey = obj["LicenseKey"],
            let applicationID = obj["ApplicationID"],
            let site = obj["Site"].flatMap(TowerSignalSite.init(rawValue:)),
            let env = obj["Environment"]
        else {
            throw ProgrammerError(description: "Missing required Info.plist keys")
        }

        self = .init(licenseKey: licenseKey, applicationID: applicationID, site: site, env: env)
    }
}

extension TestInfo {
    static var empty: Self {
        .init(
            licenseKey: "",
            applicationID: "",
            site: .towersignal,
            env: "e2e"
        )
    }
}

extension TowerSignal.Configuration {
    static func e2e(info: TestInfo) -> Self {
        .init(
            licenseKey: info.licenseKey,
            env: info.env,
            site: info.site,
            uploadFrequency: .frequent
        )
    }
}
