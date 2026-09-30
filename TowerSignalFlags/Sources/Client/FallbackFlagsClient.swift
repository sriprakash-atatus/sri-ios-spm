/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; renamed
// `dd*` types to `TowerSignal*`; renamed the `DD` symbol prefix to `AT`; rebranded the licence header.

import Foundation
import TowerSignalInternal

internal final class FallbackFlagsClient: FlagsClientProtocol {
    private let name: String
    private weak var core: (any TowerSignalCoreProtocol)?

    let state: FlagsStateObservable = NOPStateObservable.error

    init(name: String, core: any TowerSignalCoreProtocol) {
        self.name = name
        self.core = core
    }

    func setEvaluationContext(
        _ context: FlagsEvaluationContext,
        completion: @escaping (Result<Void, FlagsError>) -> Void
    ) {
        reportIssue(
            """
            Using fallback client to set the evaluation context. \
            Ensure that a client named '\(name)' is created before using it.
            """,
            in: core
        )
        completion(.failure(.clientNotInitialized))
    }

    func getDetails<T>(key: String, defaultValue: T) -> FlagDetails<T> where T: FlagValue, T: Equatable {
        AT.logger.error(
            """
            Using fallback client to get '\(key)' value. \
            Ensure that a client named '\(name)' is created before using it.
            """
        )
        return FlagDetails(key: key, value: defaultValue, error: .providerNotReady)
    }
}

// MARK: - Internal methods consumed by the React Native SDK

extension FallbackFlagsClient: FlagsClientInternal {
    func getFlagAssignments() -> [String: FlagAssignment]? {
        AT.logger.error(
            """
            Using fallback client to get all flag values. \
            Ensure that a client named '\(name)' is created before using it.
            """
        )
        return nil
    }

    func sendFlagEvaluation(key: String, assignment: FlagAssignment, context: FlagsEvaluationContext) {
        AT.logger.error(
            """
            Using fallback client to track '\(key)'. \
            Ensure that a client named '\(name)' is created before using it.
            """
        )
    }
}
