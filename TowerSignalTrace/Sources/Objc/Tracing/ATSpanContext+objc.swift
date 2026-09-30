/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed the `DD` symbol prefix to `AT`; rebranded the licence header.

import Foundation

@objc(ATSpanContextObjc)
@objcMembers
internal class objc_SpanContextObjc: NSObject, objc_OTSpanContext {
    let swiftSpanContext: OTSpanContext

    internal init(swiftSpanContext: OTSpanContext) {
        self.swiftSpanContext = swiftSpanContext
    }

    // MARK: - Open Tracing Objective-C Interface

    func forEachBaggageItem(_ callback: (_ key: String, _ value: String) -> Bool) {
        // Corresponds to:
        // - (void)forEachBaggageItem:(BOOL (^) (NSString* key, NSString* value))callback;
        swiftSpanContext.forEachBaggageItem(callback: callback)
    }
}
