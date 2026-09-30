/*
* Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
* This product includes software developed at TowerSignal (https://www.towersignal.com/).
* Copyright 2026-Present TowerSignal, Inc.
*/

// ATCHG: TowerSignal SDK migration - renamed module imports `ddCore` -> `TowerSignalCore`, `ddInternal` ->
// `TowerSignalInternal`; renamed the `DD` symbol prefix to `AT`; rebranded the licence header.

#import <XCTest/XCTest.h>
@import TowerSignalCore;
@import TowerSignalInternal;

@interface ATTowerSignal_apiTests : XCTestCase
@end

/*
 * Objc APIs smoke tests - only check if the interface is available to Objc.
 */
@implementation ATTowerSignal_apiTests

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"

- (void)testDDTrackingConsentAPI {
    [ATTrackingConsent granted];
    [ATTrackingConsent notGranted];
    [ATTrackingConsent pending];
}

- (void)testDDTowerSignal {
    ATConfiguration *configuration = [[ATConfiguration alloc] initWithClientToken:@"abc" env:@"def"];

    [ATTowerSignal initializeWithConfiguration:configuration trackingConsent:[ATTrackingConsent notGranted]];

    [ATTowerSignal isInitialized];

    ATCoreLoggerLevel verbosity = [ATTowerSignal verbosityLevel];
    [ATTowerSignal setVerbosityLevel:verbosity];

    [ATTowerSignal setUserInfoWithUserId:@"" name:@"" email:@"" extraInfo:@{}];
    [ATTowerSignal addUserExtraInfo:@{}];
    [ATTowerSignal setTrackingConsentWithConsent:[ATTrackingConsent notGranted]];

    [ATTowerSignal clearAllData];
    [ATTowerSignal stopInstance];
}

- (void)testDDTowerSignalInstanceNameAPI {
    NSString *instanceName = @"test-instance";
    ATConfiguration *configuration = [[ATConfiguration alloc] initWithClientToken:@"abc" env:@"def"];

    [ATTowerSignal initializeWithConfiguration:configuration trackingConsent:[ATTrackingConsent notGranted] instanceName:instanceName];

    XCTAssertTrue([ATTowerSignal isInitializedWithInstanceName:instanceName]);

    [ATTowerSignal setUserInfoWithUserId:@"user-id" instanceName:instanceName name:@"name" email:@"email" extraInfo:@{}];
    [ATTowerSignal addUserExtraInfo:@{} instanceName:instanceName];
    [ATTowerSignal clearUserInfoWithInstanceName:instanceName];

    [ATTowerSignal setAccountInfoWithAccountId:@"account-id" instanceName:instanceName name:@"name" extraInfo:@{}];
    [ATTowerSignal addAccountExtraInfo:@{} instanceName:instanceName];
    [ATTowerSignal clearAccountInfoWithInstanceName:instanceName];

    [ATTowerSignal setTrackingConsentWithConsent:[ATTrackingConsent notGranted] instanceName:instanceName];
    [ATTowerSignal clearAllDataWithInstanceName:instanceName];
    [ATTowerSignal stopInstanceWithInstanceName:instanceName];
}

#pragma clang diagnostic pop

@end
