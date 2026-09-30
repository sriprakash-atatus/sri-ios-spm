/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; renamed
// `dd*` types to `TowerSignal*`; rebranded the licence header.

import Foundation
import TowerSignalInternal

extension RUMAccount {
    init?(context: TowerSignalContext) {
        guard let accountInfo = context.accountInfo else {
            return nil
        }

        self.init(accountInfo: accountInfo)
    }

    init(accountInfo: AccountInfo) {
        self.init(
            id: accountInfo.id,
            name: accountInfo.name,
            accountInfo: accountInfo.extraInfo
        )
    }
}
