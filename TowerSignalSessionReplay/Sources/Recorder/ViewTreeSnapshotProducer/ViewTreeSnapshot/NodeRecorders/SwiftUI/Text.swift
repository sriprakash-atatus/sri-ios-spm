/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - rebranded the licence header.

#if os(iOS)

import Foundation
import SwiftUI

internal struct StyledTextContentView {
    let text: ResolvedStyledText.StringDrawing
}

internal struct ResolvedStyledText {
    internal struct StringDrawing {
        let storage: NSAttributedString
    }
}

#endif
