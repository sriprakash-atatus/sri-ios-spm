/*
* Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
* This product includes software developed at TowerSignal (https://www.towersignal.com/).
* Copyright 2026-Present TowerSignal, Inc.
*/

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; renamed the
// `DD` symbol prefix to `AT`; rebranded the licence header.

#import <XCTest/XCTest.h>
@import TowerSignalInternal;

@interface ATInternalLogger_apiTests : XCTestCase
@end

/*
 * `ATInternalLogger` APIs smoke tests - only check if the interface is available to Objc.
 */
@implementation ATInternalLogger_apiTests

- (void)testDDInternalLogger {

    [ATInternalLogger consolePrint:@"" :ATCoreLoggerLevelWarn];
    [ATInternalLogger telemetryDebugWithId:@"" message:@""];
    [ATInternalLogger telemetryErrorWithId:@"" message:@"" kind:@"" stack:@""];
}

@end
