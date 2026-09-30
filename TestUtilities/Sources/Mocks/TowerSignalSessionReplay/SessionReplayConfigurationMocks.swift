/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; rebranded the
// licence header.

import Foundation
import TowerSignalInternal

extension SessionReplayPrivacyLevel: AnyMockable, RandomMockable {
    public static func mockAny() -> Self {
        .allow
    }

    public static func mockRandom() -> Self {
        [.allow, .mask, .maskUserInput].randomElement()!
    }
}

extension TextAndInputPrivacyLevel: AnyMockable, RandomMockable {
    public static func mockAny() -> Self {
        .maskSensitiveInputs
    }

    public static func mockRandom() -> Self {
        [.maskAll, .maskAllInputs, .maskSensitiveInputs].randomElement()!
    }
}

extension ImagePrivacyLevel: AnyMockable, RandomMockable {
    public static func mockAny() -> Self {
        .maskNonBundledOnly
    }

    public static func mockRandom() -> Self {
        [.maskNonBundledOnly, .maskAll, .maskNone].randomElement()!
    }
}

extension TouchPrivacyLevel: AnyMockable, RandomMockable {
    public static func mockAny() -> Self {
        .show
    }

    public static func mockRandom() -> Self {
        [.show, .hide].randomElement()!
    }
}
