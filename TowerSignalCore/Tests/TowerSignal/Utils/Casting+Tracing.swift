/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddTrace` -> `TowerSignalTrace`; renamed `dd*`
// types to `TowerSignal*`; renamed the `DD` symbol prefix to `AT`; rebranded the `dd` name to `TowerSignal` in
// comments and docs; rebranded the licence header.

@testable import TowerSignalTrace

/*
 NOTE: The casting methods defined here do shadow the ones defined in `TowerSignal.Casting`.
 The difference is that here in tests we do force unwrapping (`as!`), whereas in `TowerSignal` we do `as?` with a warning.

 This is needed for expressiveness in testing, where i.e. `XCTAssertNil(span.context.dd?.parentID)` may give a false positive
 without considering if the `parentID` is `nil`. Using `span.context.dd.parentID` mitigates it.
 */

internal extension OTTracer {
    var dd: TowerSignalTracer { self as! TowerSignalTracer }
}

internal extension OTSpan {
    var dd: ATSpan { self as! ATSpan }
}

internal extension OTSpanContext {
    var dd: ATSpanContext { self as! ATSpanContext }
}
