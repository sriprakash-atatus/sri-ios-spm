/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; rebranded the
// licence header.

import Foundation
import TowerSignalInternal

/// Writer performing writes asynchronously on a given queue.
internal struct AsyncWriter: Writer {
    private let writer: Writer
    private let queue: DispatchQueue

    init(execute otherWriter: Writer, on queue: DispatchQueue) {
        self.writer = otherWriter
        self.queue = queue
    }

    func write<T: Encodable, M: Encodable>(value: T, metadata: M?, completion: @escaping CompletionHandler) {
        queue.async { writer.write(value: value, metadata: metadata, completion: completion) }
    }
}

internal struct NOPWriter: Writer {
    func write<T: Encodable, M: Encodable>(value: T, metadata: M?, completion: @escaping CompletionHandler) {
        completion()
    }
}
