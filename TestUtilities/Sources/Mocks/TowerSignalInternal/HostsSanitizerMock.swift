/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; rebranded the
// licence header.

import TowerSignalInternal

public class HostsSanitizerMock: HostsSanitizing {
    public private(set) var sanitizations = [(hosts: Set<String>, warningMessage: String)]()

    public init() {}

    public func sanitized(hosts: Set<String>, warningMessage: String) -> Set<String> {
        sanitizations.append((hosts: hosts, warningMessage: warningMessage))
        return hosts
    }

    public func sanitized(
        hostsWithTracingHeaderTypes: [String: Set<TracingHeaderType>],
        warningMessage: String
    ) -> [String: Set<TracingHeaderType>] {
        sanitizations.append((hosts: Set(hostsWithTracingHeaderTypes.keys), warningMessage: warningMessage))
        return hostsWithTracingHeaderTypes
    }
}
