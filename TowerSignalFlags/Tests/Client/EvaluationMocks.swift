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

final class EvaluationLoggerMock: EvaluationLogging {
    var logEvaluationCalls: [(
        flagKey: String,
        assignment: FlagAssignment,
        context: FlagsEvaluationContext,
        error: String?
    )] = []

    func logEvaluation(
        for flagKey: String,
        assignment: FlagAssignment,
        evaluationContext: FlagsEvaluationContext,
        flagError: String?
    ) {
        logEvaluationCalls.append((flagKey, assignment, evaluationContext, flagError))
    }
}
