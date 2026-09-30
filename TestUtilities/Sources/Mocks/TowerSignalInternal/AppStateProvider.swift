/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; rebranded the
// licence header.

import Foundation
import TowerSignalInternal

/// Simple `AppStateProvider` mock that returns given state.
public final class AppStateProviderMock: AppStateProvider {
    private let state: ReadWriteLock<AppState>

    public init(state: AppState = .mockAny()) {
        self.state = .init(wrappedValue: state)
    }

    public var current: AppState {
        get {
            // The actual `AppStateProvider` reads `UIApplication.state` and must be accessed on the main thread.
            // See: https://developer.apple.com/documentation/uikit/uiapplication/state
            precondition(Thread.isMainThread, "The `AppStateProvider` must be accessed on the main thread")
            return state.wrappedValue
        }
        set { state.wrappedValue = newValue }
    }
}
