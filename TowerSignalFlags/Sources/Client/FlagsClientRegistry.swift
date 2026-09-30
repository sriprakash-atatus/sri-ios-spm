/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; renamed the
// `DD` symbol prefix to `AT`; rebranded the licence header.

import Foundation
import TowerSignalInternal

internal final class FlagsClientRegistry {
    @ReadWriteLock
    private var clients: [String: FlagsClientProtocol] = [:]

    func register(_ client: FlagsClientProtocol, named name: String) {
        guard !isRegistered(clientName: name) else {
            AT.logger.warn("A flags client with name \(name) has already been registered.")
            return
        }
        clients[name] = client
    }

    func isRegistered(clientName: String) -> Bool {
        clients[clientName] != nil
    }

    @discardableResult
    func unregisterClient(named name: String) -> FlagsClientProtocol? {
        clients.removeValue(forKey: name)
    }

    func client(named name: String) -> FlagsClientProtocol? {
        clients[name]
    }
}
