/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; repointed the
// intake host at the TowerSignal site; rebranded the `dd` name to `TowerSignal` in comments and docs; rebranded
// the licence header.

import Foundation
import CodeGeneration
import CodeDecoration

internal func generateSRSwiftModels(from schema: URL) throws -> String {
    let generator = ModelsGenerator()

    let template = OutputTemplate(
        header: """
            /*
             * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
             * This product includes software developed at TowerSignal (https://www.towersignal.com/).
             * Copyright 2026-Present TowerSignal, Inc.
             */

            #if os(iOS)
            import TowerSignalInternal

            // This file was generated from JSON Schema. Do not modify it directly.

            // swiftlint:disable all

            internal protocol SRDataModel: Codable {}

            """,
        footer: """
        #endif
        """
    )
    let printer = SwiftPrinter(
        configuration: .init(
            accessLevel: .spi
        )
    )

    return try generator
        .generateCode(from: schema)
        .decorate(using: SRCodeDecorator())
        .sortTypes()
        .print(using: template, and: printer)
}

internal func generateSRObjcInteropModels(from schema: URL, skip: Set<String>) throws -> String {
    throw Exception.unimplemented("Generating Objc-interop code for Session Replay models is not supported.")
}
