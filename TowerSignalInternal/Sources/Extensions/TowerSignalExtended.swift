/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed `dd*` types to `TowerSignal*`; rebranded the `dd` name to
// `TowerSignal` in comments and docs; rebranded the licence header.

import Foundation

/// Type that acts as a generic extension point for all `TowerSignalExtended` types.
public struct TowerSignalExtension<ExtendedType> {
    /// Stores the type or meta-type of any extended type.
    public private(set) var type: ExtendedType

    /// Create an instance from the provided value.
    ///
    /// - Parameter type: Instance being extended.
    public init(_ type: ExtendedType) {
        self.type = type
    }
}

/// Protocol describing the `dd` extension points for TowerSignal extended types.
public protocol TowerSignalExtended {
    /// Type being extended.
    associatedtype ExtendedType

    /// Static TowerSignal extension point.
    static var dd: TowerSignalExtension<ExtendedType>.Type { get set }
    /// Instance TowerSignal extension point.
    var dd: TowerSignalExtension<ExtendedType> { get set }
}

extension TowerSignalExtended {
    /// Static TowerSignal extension point.
    public static var dd: TowerSignalExtension<Self>.Type {
        get { TowerSignalExtension<Self>.self }
        set {}
    }

    /// Instance TowerSignal extension point.
    public var dd: TowerSignalExtension<Self> {
        get { TowerSignalExtension(self) }
        set {}
    }
}

extension Array: TowerSignalExtended {}
extension Dictionary: TowerSignalExtended {}
