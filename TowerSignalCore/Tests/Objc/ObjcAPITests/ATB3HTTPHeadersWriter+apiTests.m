/*
* Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
* This product includes software developed at TowerSignal (https://www.towersignal.com/).
* Copyright 2026-Present TowerSignal, Inc.
*/

// ATCHG: TowerSignal SDK migration - renamed module imports `ddTrace` -> `TowerSignalTrace`; renamed the `DD`
// symbol prefix to `AT`; rebranded the licence header.

#import <XCTest/XCTest.h>
@import TowerSignalTrace;

@interface ATB3HTTPHeadersWriter_apiTests : XCTestCase
@end

/*
 * Objc APIs smoke tests - only check if the interface is available to Objc.
 */
@implementation ATB3HTTPHeadersWriter_apiTests

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"

- (void)testInitWithSamplingRate {
    [[ATB3HTTPHeadersWriter alloc] initWithInjectEncoding:ATInjectEncodingSingle
                                    traceContextInjection:ATTraceContextInjectionAll];
}

#pragma clang diagnostic pop

@end
