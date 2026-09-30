/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed `dd*` types to `TowerSignal*`; renamed the `DD` symbol prefix to
// `AT`; rebranded the licence header.

import Foundation
import class TowerSignalInternal.HTTPHeadersWriter

@objc(ATHTTPHeadersWriter)
@objcMembers
@_spi(objc)
public final class objc_HTTPHeadersWriter: NSObject {
    let swiftHTTPHeadersWriter: HTTPHeadersWriter

    public var traceHeaderFields: [String: String] {
        swiftHTTPHeadersWriter.traceHeaderFields
    }

    public init(traceContextInjection: objc_TraceContextInjection) {
        swiftHTTPHeadersWriter = HTTPHeadersWriter(traceContextInjection: traceContextInjection.swiftType)
    }
}
