/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`,
// `ddSessionReplay` -> `TowerSignalSessionReplay`; renamed `dd*` types to `TowerSignal*`; rebranded the
// licence header.

import SwiftUI
import TowerSignalSessionReplay
import TowerSignalInternal
import SRFixtures

@available(iOS 16.0, *)
struct SwiftUIViewWithPrivacyOverrides: View {
    private let core: TowerSignalCoreProtocol

    init(core: TowerSignalCoreProtocol) {
        self.core = core
    }

    var body: some View {
        SessionReplayPrivacyView(imagePrivacy: .maskNonBundledOnly, core: core) {
            VStack(spacing: 10) {
                SessionReplayPrivacyView(textAndInputPrivacy: .maskAllInputs, core: core) {
                    Text("Hello, SwiftUI!")
                        .font(.headline)

                    Label("Label with Icon", systemImage: "star.fill")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    TextField("Enter text", text: .constant("Placeholder text"))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(8)
                }

                SessionReplayPrivacyView(hide: true, core: core) {
                    Button(action: {}) {
                        Text("SwiftUI Button")
                            .padding()
                            .foregroundStyle(.background)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }

                Divider()
                    .frame(height: 2)
                    .background(Color.purple)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 6)

                // "Bundled" image
                Image.towersignalLogo
                    .resizable()
                    .scaledToFit()
                    .background(Color.purple)
                    .frame(width: 120, height: 120)
                    .clipped()

                // "Content" image
                Image.flowers
                    .resizable()
                    .scaledToFit()
                    .background(Color.purple)
                    .frame(width: 120, height: 120)
                    .clipped()

                List {
                    Text("Item 1")
                    SessionReplayPrivacyView(textAndInputPrivacy: .maskAll, core: core) {
                        Text("Item 2")
                    }
                }.frame(height: 140)
            }
        }
    }
}
