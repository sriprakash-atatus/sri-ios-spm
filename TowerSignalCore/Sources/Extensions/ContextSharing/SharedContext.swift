/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; renamed
// `dd*` types to `TowerSignal*`; renamed the `DD` symbol prefix to `AT`; rebranded the `dd` name to
// `TowerSignal` in comments and docs; rebranded the licence header.

import Foundation
import TowerSignalInternal

/// Objective-C compatible type that exposes selected properties from `TowerSignalContext` to Objective-C.
///
/// This class is intended for internal use, primarily by cross-platform libraries that need to access
/// TowerSignal context information from Objective-C code. Can be extended with other properties as long as
/// they are Objective-C compatible.
@objc(ATSharedContext)
@objcMembers
@_spi(Internal)
public class SharedContext: NSObject {
    public let userId: String?
    public let accountId: String?

    init(towersignalContext: TowerSignalContext) {
        userId = towersignalContext.userInfo?.id
        accountId = towersignalContext.accountInfo?.id
    }
}
