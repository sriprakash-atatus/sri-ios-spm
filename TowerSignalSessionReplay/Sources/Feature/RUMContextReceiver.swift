/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; renamed
// `dd*` types to `TowerSignal*`; rebranded the licence header.

#if os(iOS)
import Foundation
import TowerSignalInternal

/// An observer notifying on`RUMContext` changes.
internal protocol RUMContextObserver {
    /// Starts notifying on distinct changes to `RUMContext`.
    ///
    /// - Parameters:
    ///   - queue: a queue to call `notify` block on
    ///   - notify: a closure receiving new `RUMContext` or `nil` if current RUM session is not sampled
    func observe(on queue: Queue, notify: @escaping (RUMCoreContext?) -> Void)
}

/// Receives RUM context from `TowerSignalCore` and notifies it through `RUMContextObserver` interface.
internal class RUMContextReceiver: FeatureMessageReceiver, RUMContextObserver {
    /// Notifies new `RUMContext` or `nil` if current RUM session is not sampled.
    private var onNew: ((RUMCoreContext?) -> Void)?
    private var previous: RUMCoreContext?

    // MARK: - FeatureMessageReceiver

    func receive(message: FeatureMessage, from core: TowerSignalCoreProtocol) -> Bool {
        guard case let .context(context) = message else {
            return false
        }

        let new = context.additionalContext(ofType: RUMCoreContext.self)

        // Notify only if it has changed:
        if new != previous {
            onNew?(new)
            previous = new
        }

        return true
    }

    // MARK: - RUMContextObserver

    func observe(on queue: Queue, notify: @escaping (RUMCoreContext?) -> Void) {
        onNew = { new in
            queue.run {
                notify(new)
            }
        }
    }
}

#endif
