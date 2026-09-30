/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed `dd*` types to `TowerSignal*`; renamed the `DD` symbol prefix to
// `AT`; rebranded the licence header.

import Foundation
import class TowerSignalInternal.B3HTTPHeadersWriter

@objc(ATInjectEncoding)
@_spi(objc)
public enum objc_InjectEncoding: Int {
    case multiple = 0
    case single = 1
}

private extension B3HTTPHeadersWriter.InjectEncoding {
    init(_ value: objc_InjectEncoding) {
        switch value {
        case .single:
            self = .single
        case .multiple:
            self = .multiple
        }
    }
}

@objc(ATB3HTTPHeadersWriter)
@objcMembers
@_spi(objc)
public final class objc_B3HTTPHeadersWriter: NSObject {
    let swiftB3HTTPHeadersWriter: B3HTTPHeadersWriter

    public var traceHeaderFields: [String: String] {
        swiftB3HTTPHeadersWriter.traceHeaderFields
    }

    public init(
        injectEncoding: objc_InjectEncoding = .single,
        traceContextInjection: objc_TraceContextInjection = .sampled
    ) {
        swiftB3HTTPHeadersWriter = B3HTTPHeadersWriter(
            injectEncoding: .init(injectEncoding),
            traceContextInjection: traceContextInjection.swiftType
        )
    }
}
