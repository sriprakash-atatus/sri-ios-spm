/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - rebranded the licence header.

import SwiftUI

struct RUMAutoContentView: View {
    var body: some View {
        TabView {
            CharactersView()
                .tabItem {
                    Label("Characters", systemImage: "person.3")
                }

            LocationsView()
                .tabItem {
                    Label("Locations", systemImage: "map")
                }

            EpisodesView()
                .tabItem {
                    Label("Episodes", systemImage: "tv")
                }

            DocsView()
                .tabItem {
                    Label("Docs", systemImage: "doc.text")
                }
        }
        .tint(.purple)
    }
}

#Preview {
    RUMAutoContentView()
}
