/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddSessionReplay` -> `TowerSignalSessionReplay`;
// rebranded the licence header.

import XCTest
@_spi(Internal)
@testable import TowerSignalSessionReplay

@available(iOS 16.0, *)
@MainActor
final class SRLayerSnapshotTests: LayerSnapshotTestCase {
    private let snapshotsFolderPath = "_snapshots_/png"
    private var shouldRecord = false

    func testSwiftUIText() async throws {
        try await takeLayerSnapshotFor(
            TextFixtureView(),
            with: TextAndInputPrivacyLevel.allCases,
            shouldRecord: shouldRecord,
            folderPath: snapshotsFolderPath
        )
    }

    func testBasicControlsAndIndicators() async throws {
        try await takeLayerSnapshotFor(
            BasicControlsAndIndicatorsFixtureView(),
            imagePrivacyLevel: .maskAll,
            shouldRecord: shouldRecord,
            folderPath: snapshotsFolderPath
        )
    }

    func testSteppers() async throws {
        try await takeLayerSnapshotFor(
            StepperFixtureView(),
            imagePrivacyLevel: .maskAll,
            shouldRecord: shouldRecord,
            folderPath: snapshotsFolderPath
        )
    }

    func testAlert() async throws {
        try await takeLayerSnapshotFor(
            AlertFixtureView(),
            with: [.maskAll, .maskSensitiveInputs],
            shouldRecord: shouldRecord,
            folderPath: snapshotsFolderPath
        )
    }

    func testTab() async throws {
        try await takeLayerSnapshotFor(
            TabFixtureView(),
            with: [.maskAll, .maskSensitiveInputs],
            shouldRecord: shouldRecord,
            folderPath: snapshotsFolderPath
        )
    }

    func testToolbar() async throws {
        try await takeLayerSnapshotFor(
            ToolbarFixtureView(),
            shouldRecord: shouldRecord,
            folderPath: snapshotsFolderPath
        )
    }
}
