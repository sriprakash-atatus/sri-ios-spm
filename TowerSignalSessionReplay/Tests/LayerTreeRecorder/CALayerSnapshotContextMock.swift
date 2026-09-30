/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`,
// `ddSessionReplay` -> `TowerSignalSessionReplay`; rebranded the licence header.

#if os(iOS)
import TowerSignalInternal
import UIKit
import WebKit

@testable import TowerSignalSessionReplay

@available(iOS 13.0, tvOS 13.0, *)
extension CALayerSnapshot.Context {
    static func mockAny(
        textAndInputPrivacyLevel: TextAndInputPrivacyLevel = .maskAll,
        imagePrivacyLevel: ImagePrivacyLevel = .maskAll,
        webViewCache: NSHashTable<WKWebView> = .weakObjects(),
        embeddedContentViewCache: NSHashTable<UIView> = .weakObjects()
    ) -> Self {
        .init(
            textAndInputPrivacyLevel: textAndInputPrivacyLevel,
            imagePrivacyLevel: imagePrivacyLevel,
            webViewCache: webViewCache,
            embeddedContentViewCache: embeddedContentViewCache
        )
    }
}
#endif
