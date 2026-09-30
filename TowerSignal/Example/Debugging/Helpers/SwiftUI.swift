/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed `dd*` types to `TowerSignal*`; rebranded the `dd` name to
// `TowerSignal` in comments and docs; rebranded the licence header.

import SwiftUI

@available(iOS 13, tvOS 13,*)
extension Color {
    /// TowerSignal purple.
    static var towersignalPurple: Color {
        return Color(UIColor(red: 99/256, green: 44/256, blue: 166/256, alpha: 1))
    }

    static var rumViewColor: Color {
        return Color(UIColor(red: 0/256, green: 107/256, blue: 194/256, alpha: 1))
    }

    static var rumResourceColor: Color {
        return Color(UIColor(red: 113/256, green: 184/256, blue: 231/256, alpha: 1))
    }

    static var rumActionColor: Color {
        return Color(UIColor(red: 150/256, green: 95/256, blue: 204/256, alpha: 1))
    }

    static var rumErrorColor: Color {
        return Color(UIColor(red: 235/256, green: 54/256, blue: 7/256, alpha: 1))
    }
}

@available(iOS 13, tvOS 13,*)
internal struct TowerSignalButtonStyle: ButtonStyle {
    func makeBody(configuration: TowerSignalButtonStyle.Configuration) -> some View {
        return configuration.label
            .font(.system(size: 12, weight: .medium))
            .padding(6)
            .background(Color.towersignalPurple)
            .foregroundColor(.white)
            .cornerRadius(6)
    }
}
