/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; renamed the
// `DD` symbol prefix to `AT`; repointed the intake host at the TowerSignal site; rebranded the `dd` name to
// `TowerSignal` in comments and docs; rebranded the licence header.

import Foundation
import CodeGeneration
import CodeDecoration

internal func generateRUMSwiftModels(from schema: URL) throws -> String {
    let generator = ModelsGenerator()

    let template = OutputTemplate(
        header: """
            /*
             * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
             * This product includes software developed at TowerSignal (https://www.towersignal.com/).
             * Copyright 2026-Present TowerSignal, Inc.
             */

            // This file was generated from JSON Schema. Do not modify it directly.

            // swiftlint:disable all

            public protocol RUMDataModel: Codable {}

            """,
        footer: ""
    )
    let printer = SwiftPrinter(
        configuration: .init(
            accessLevel: .public
        )
    )

    return try generator
        .generateCode(from: schema)
        .decorate(using: RUMCodeDecorator())
        .sortTypes()
        .print(using: template, and: printer)
}

internal func generateRUMObjcInteropModels(from schema: URL, skip typesToSkip: Set<String>) throws -> String {
    let generator = ModelsGenerator()
    let objcRuntimeNameOverrides = [
        "objc_RUMErrorEventErrorMeta": "ATRUMErrorEventErrorMetaInfo"
    ]

    let template = OutputTemplate(
        header: """
            /*
             * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
             * This product includes software developed at TowerSignal (https://www.towersignal.com/).
             * Copyright 2026-Present TowerSignal, Inc.
             */

            import Foundation
            import TowerSignalInternal

            // This file was generated from JSON Schema. Do not modify it directly.

            // swiftlint:disable force_unwrapping

            """,
        footer: """

            // swiftlint:enable force_unwrapping

            """
    )
    let printer = ObjcInteropPrinter(
        objcTypeNamesPrefix: "objc_",
        objcRuntimeNameOverrides: objcRuntimeNameOverrides
    )

    return try generator
        .generateCode(from: schema)
        .skip(types: typesToSkip)
        .decorate(using: RUMCodeDecorator())
        .sortTypes()
        .print(using: template, and: printer)
}
