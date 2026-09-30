/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; rebranded the
// licence header.

#if os(iOS)

import Foundation
import TowerSignalInternal

extension StyledTextContentView: Reflection {
    init(from reflector: Reflector) throws {
        text = try reflector.descendant("text")
    }
}

extension ResolvedStyledText.StringDrawing: Reflection {
    init(from reflector: Reflector) throws {
        storage = try reflector.descendant("storage")
    }
}

#endif
