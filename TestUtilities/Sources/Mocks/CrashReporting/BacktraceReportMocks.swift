/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; renamed the
// `DD` symbol prefix to `AT`; rebranded the licence header.

import TowerSignalInternal

extension BacktraceReport: AnyMockable, RandomMockable {
    public static func mockAny() -> BacktraceReport {
        return .mockWith()
    }

    public static func mockRandom() -> BacktraceReport {
        return BacktraceReport(
            stack: .mockRandom(),
            threads: .mockRandom(),
            binaryImages: .mockRandom(),
            wasTruncated: .mockRandom()
        )
    }

    public static func mockWith(
        stack: String = .mockAny(),
        threads: [ATThread] = .mockAny(),
        binaryImages: [BinaryImage] = .mockAny(),
        wasTruncated: Bool = .mockAny()
    ) -> BacktraceReport {
        return BacktraceReport(
            stack: stack,
            threads: threads,
            binaryImages: binaryImages,
            wasTruncated: wasTruncated
        )
    }
}
