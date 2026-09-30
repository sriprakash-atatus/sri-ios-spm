/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed `dd*` types to `TowerSignal*`; rebranded the licence header.

import Foundation

extension JSONEncoder: TowerSignalExtended { }

extension TowerSignalExtension where ExtendedType == JSONEncoder {
    public static func `default`() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .custom { date, encoder in
            var container = encoder.singleValueContainer()
            let formatted = iso8601DateFormatter.string(from: date)
            try container.encode(formatted)
        }
        if #available(iOS 13, tvOS 13, *) {
            encoder.outputFormatting = [.withoutEscapingSlashes]
        }
        return encoder
    }
}
