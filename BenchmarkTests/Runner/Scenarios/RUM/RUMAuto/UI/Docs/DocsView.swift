/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - rebranded the licence header.

import SwiftUI
import WebKit

struct DocsView: UIViewRepresentable {
    let url: URL = .init(string: "https://rickandmortyapi.com/documentation")!

    func makeUIView(context _: Context) -> some UIView {
        let webView = WKWebView()
        webView.isInspectable = true
        webView.load(URLRequest(url: url))

        return webView
    }

    func updateUIView(_: UIViewType, context _: Context) {}
}

#Preview {
    DocsView()
}
