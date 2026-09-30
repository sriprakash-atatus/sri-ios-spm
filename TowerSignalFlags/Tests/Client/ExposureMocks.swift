/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddFlags` -> `TowerSignalFlags`, `ddInternal`
// -> `TowerSignalInternal`; rebranded the licence header.

import XCTest
import TowerSignalInternal
import TestUtilities

@_spi(Internal)
@testable import TowerSignalFlags

extension ExposureEvent: AnyMockable, RandomMockable {
    public static func mockAny() -> ExposureEvent {
        .init(
            timestamp: .mockAny(),
            allocation: .mockAny(),
            flag: .mockAny(),
            variant: .mockAny(),
            subject: .mockAny()
        )
    }

    public static func mockRandom() -> ExposureEvent {
        .init(
            timestamp: .mockRandom(),
            allocation: .mockRandom(),
            flag: .mockRandom(),
            variant: .mockRandom(),
            subject: .mockRandom()
        )
    }
}

extension ExposureEvent.Identifier: AnyMockable, RandomMockable {
    public static func mockAny() -> ExposureEvent.Identifier {
        .init(key: .mockAny())
    }

    public static func mockRandom() -> ExposureEvent.Identifier {
        .init(key: .mockRandom())
    }
}

extension ExposureEvent.Subject: AnyMockable, RandomMockable {
    public static func mockAny() -> ExposureEvent.Subject {
        .init(id: .mockAny(), attributes: .mockAny())
    }

    public static func mockRandom() -> ExposureEvent.Subject {
        .init(id: .mockRandom(), attributes: .mockRandom())
    }
}

final class ExposureLoggerMock: ExposureLogging {
    var logExposureCalls: [(
        flagKey: String,
        assignment: FlagAssignment,
        context: FlagsEvaluationContext
    )] = []

    func logExposure(
        for flagKey: String,
        assignment: FlagAssignment,
        evaluationContext: FlagsEvaluationContext
    ) {
        logExposureCalls.append((flagKey, assignment, evaluationContext))
    }
}
