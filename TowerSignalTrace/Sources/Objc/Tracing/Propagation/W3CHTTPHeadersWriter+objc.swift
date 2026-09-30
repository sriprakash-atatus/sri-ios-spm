/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed `dd*` types to `TowerSignal*`; renamed the `DD` symbol prefix to
// `AT`; rebranded the licence header.

import Foundation
import class TowerSignalInternal.W3CHTTPHeadersWriter

@objc(ATW3CHTTPHeadersWriter)
@objcMembers
@_spi(objc)
public final class objc_W3CHTTPHeadersWriter: NSObject {
    let swiftW3CHTTPHeadersWriter: W3CHTTPHeadersWriter

    public var traceHeaderFields: [String: String] {
        swiftW3CHTTPHeadersWriter.traceHeaderFields
    }

    public init(
        traceContextInjection: objc_TraceContextInjection
    ) {
        swiftW3CHTTPHeadersWriter = W3CHTTPHeadersWriter(
            tracestate: [:],
            traceContextInjection: traceContextInjection.swiftType
        )
    }
}
