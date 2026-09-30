/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; rebranded the
// licence header.

#if os(iOS)
import TowerSignalInternal
import UIKit

@available(iOS 13.0, tvOS 13.0, *)
internal struct ImageSnapshotResource: Resource {
    let image: UIImage

    var mimeType: String {
        "image/png"
    }

    func calculateIdentifier() -> String {
        image.dd.identifier
    }

    func calculateData() -> Data {
        image.dd.pngData() ?? Data()
    }
}
#endif
