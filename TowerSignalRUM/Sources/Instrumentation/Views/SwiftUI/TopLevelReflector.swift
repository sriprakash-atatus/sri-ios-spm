/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; rebranded the
// licence header.

import TowerSignalInternal

// MARK: - TopLevelReflector
/// Protocol defining an interface for reflection-based object inspection.
/// `TopLevelReflector` provides a consistent way to navigate through object structures
/// by traversing paths of properties.
internal protocol TopLevelReflector {
    /// Attempts to find a descendant at the specified path.
    func descendant(_ paths: [ReflectionMirror.Path]) -> Any?
}

// MARK: - Reflector
extension ReflectionMirror: TopLevelReflector {}
