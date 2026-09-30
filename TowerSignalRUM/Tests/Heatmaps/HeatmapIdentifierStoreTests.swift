/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`, `ddRUM`
// -> `TowerSignalRUM`; rebranded the licence header.

#if !os(watchOS)
import TestUtilities
import Testing
import TowerSignalInternal
import UIKit

@testable import TowerSignalRUM

@Suite(.towersignalTesting)
@MainActor
struct HeatmapIdentifierStoreTests {
    @available(iOS 13.0, tvOS 13.0, *)
    @Test
    func setHeatmapIdentifiersReplacesCurrentSnapshot() {
        // given
        let store = HeatmapIdentifierStore()
        let view1 = UIView()
        let view2 = UIView()
        let id1 = HeatmapIdentifier(rawValue: "aaa")
        let id2 = HeatmapIdentifier(rawValue: "bbb")

        // when
        store.setHeatmapIdentifiers([ObjectIdentifier(view1): id1])
        store.setHeatmapIdentifiers([ObjectIdentifier(view2): id2])

        // then
        #expect(store.heatmapIdentifier(for: ObjectIdentifier(view1)) == nil)
        #expect(store.heatmapIdentifier(for: ObjectIdentifier(view2)) == id2)
    }
}
#endif
