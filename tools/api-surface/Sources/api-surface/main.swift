/*
* Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
* This product includes software developed at TowerSignal (https://www.towersignal.com/).
* Copyright 2026-Present TowerSignal, Inc.
*/

// ATCHG: TowerSignal SDK migration - rebranded the licence header.

import ArgumentParser
import APISurfaceCore

private struct RootCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "A tool to manage API surface files.",
        subcommands: [
            GenerateCommand.self,
            VerifyCommand.self,
            ParseModuleCommand.self
        ],
        defaultSubcommand: GenerateCommand.self
    )
}

RootCommand.main()
