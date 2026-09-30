/*
* Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
* This product includes software developed at TowerSignal (https://www.towersignal.com/).
* Copyright 2026-Present TowerSignal, Inc.
*/

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; rebranded the
// `dd` name to `TowerSignal` in comments and docs; rebranded the licence header.

import Foundation
import OpenTelemetryApi
import TowerSignalInternal

extension OpenTelemetryApi.SpanId {
    /// Converts OpenTelemetry `SpanId` to TowerSignal `SpanID`.
    /// - Returns: TowerSignal `SpanID`.
    func toTowerSignal() -> SpanID {
        var data = Data(count: 8)
        self.copyBytesTo(dest: &data, destOffset: 0)
        let integerLiteral = UInt64(bigEndian: data.withUnsafeBytes { $0.loadUnaligned(as: UInt64.self) })
        return .init(integerLiteral: integerLiteral)
    }
}
