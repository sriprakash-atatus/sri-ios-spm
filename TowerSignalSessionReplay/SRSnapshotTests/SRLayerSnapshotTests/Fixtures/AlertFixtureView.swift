/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - rebranded the licence header.

import SwiftUI

@available(iOS 15.0, *)
internal struct AlertFixtureView: View {
    var body: some View {
        Text("Showing alert")
            .alert("Important message", isPresented: .constant(true)) {
                Button("Delete", role: .destructive, action: {})
                Button("Cancel", role: .cancel, action: {})
            } message: {
                Text("This is a simple alert message.")
            }
    }
}
