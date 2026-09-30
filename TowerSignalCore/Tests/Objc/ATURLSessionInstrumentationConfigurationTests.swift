/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddCore` -> `TowerSignalCore`, `ddInternal` ->
// `TowerSignalInternal`; renamed the `DD` symbol prefix to `AT`; rebranded the licence header.

import XCTest
import TestUtilities
import TowerSignalInternal
@_spi(objc)
@testable import TowerSignalCore

final class ATURLSessionInstrumentationConfigurationTests: XCTestCase {
    private var objc = objc_URLSessionInstrumentationConfiguration(delegateClass: SessionDataDelegateMock.self)
    private var swift: URLSessionInstrumentation.Configuration { objc.swiftConfig }

    func testDelegateClass() {
        XCTAssertTrue(objc.delegateClass === SessionDataDelegateMock.self)
    }

    func testFirstPartyHostsTracing() {
        objc.setFirstPartyHostsTracing(.init(hosts: ["example.com", "example.org"]))
        ATAssertReflectionEqual(swift.firstPartyHostsTracing, .trace(hosts: ["example.com", "example.org"]))

        objc.setFirstPartyHostsTracing(.init(hostsWithHeaderTypes: ["example.com": [.b3, .towersignal]]))
        ATAssertReflectionEqual(swift.firstPartyHostsTracing, .traceWithHeaders(hostsWithHeaders: ["example.com": [.b3, .towersignal]]))
    }
}
