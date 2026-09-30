/*
* Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
* This product includes software developed at TowerSignal (https://www.towersignal.com/).
* Copyright 2026-Present TowerSignal, Inc.
*/

// ATCHG: TowerSignal SDK migration - renamed module imports `ddTrace` -> `TowerSignalTrace`; renamed the `DD`
// symbol prefix to `AT`; rebranded the licence header.

#import <XCTest/XCTest.h>
@import TowerSignalTrace;

@interface ATHTTPHeadersWriter_apiTests : XCTestCase
@end

/*
 * Objc APIs smoke tests - only check if the interface is available to Objc.
 */
@implementation ATHTTPHeadersWriter_apiTests

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"

- (void)testInitWithSamplingRate {
    [[ATHTTPHeadersWriter alloc] initWithTraceContextInjection:ATTraceContextInjectionAll];
}

#pragma clang diagnostic pop

@end
