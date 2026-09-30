/*
* Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
* This product includes software developed at TowerSignal (https://www.towersignal.com/).
* Copyright 2026-Present TowerSignal, Inc.
*/

// ATCHG: TowerSignal SDK migration - rebranded the licence header.

import ArgumentParser
import SRSnapshotsCore

internal struct RootCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "CLI tool for managing Session Replay's snapshot files.",
        subcommands: [
            PushSnapshotsCommand.self,
            PullSnapshotsCommand.self,
        ]
    )
}

RootCommand.main()
