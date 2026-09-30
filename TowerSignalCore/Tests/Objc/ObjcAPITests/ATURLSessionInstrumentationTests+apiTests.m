/*
* Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
* This product includes software developed at TowerSignal (https://www.towersignal.com/).
* Copyright 2026-Present TowerSignal, Inc.
*/

// ATCHG: TowerSignal SDK migration - renamed module imports `ddCore` -> `TowerSignalCore`, `ddTrace` ->
// `TowerSignalTrace`; renamed the `DD` symbol prefix to `AT`; rebranded the licence header.

#import <XCTest/XCTest.h>
#include <sys/wait.h>
@import TowerSignalCore;
@import TowerSignalTrace;

#import <Foundation/Foundation.h>

@interface MockDelegate : NSObject <NSURLSessionDataDelegate>
@end

@implementation MockDelegate
@end

@interface ATURLSessionInstrumentationTests_apiTests : XCTestCase
@end

@implementation ATURLSessionInstrumentationTests_apiTests

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"

- (void)setUp {
    [super setUp];

    ATConfiguration *configuration = [[ATConfiguration alloc] initWithClientToken:@"abc" env:@"def"];
    [ATTowerSignal initializeWithConfiguration:configuration trackingConsent:[ATTrackingConsent notGranted]];

    ATTraceConfiguration *config = [[ATTraceConfiguration alloc] init];
    ATTraceFirstPartyHostsTracing *tracing = [[ATTraceFirstPartyHostsTracing alloc] initWithHosts:[NSSet new] sampleRate:20];
    ATTraceURLSessionTracking *urlSessionTracking = [[ATTraceURLSessionTracking alloc] initWithFirstPartyHostsTracing:tracing];
    [config setURLSessionTracking:urlSessionTracking];
    [ATTrace enableWith:config];
}

- (void)tearDown {
    [super tearDown];

    [ATTowerSignal clearAllData];
    [ATTowerSignal flushAndDeinitialize];
}

- (void)testWorkflow {
    XCTestExpectation *expectation = [self expectationWithDescription:@"task completed"];
    ATURLSessionInstrumentationConfiguration *config = [[ATURLSessionInstrumentationConfiguration alloc] initWithDelegateClass:[MockDelegate class]];
    [ATURLSessionInstrumentation enableDurationBreakdownWith:config];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:[MockDelegate new] delegateQueue:nil];
    NSURLSessionTask *task = [session dataTaskWithURL:[NSURL URLWithString:@"https://www.towersignal.com/"]
                                    completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [expectation fulfill];
    }];
    [task resume];

    [self waitForExpectationsWithTimeout:10 handler:nil];

    [ATURLSessionInstrumentation disableWithDelegateClass:[MockDelegate class]];
}

- (void)testURLSessionInstrumentationInstanceNameAPI {
    ATURLSessionInstrumentationConfiguration *config = [[ATURLSessionInstrumentationConfiguration alloc] initWithDelegateClass:[MockDelegate class]];
    NSString *instanceName = @"urlsession-test-instance";
    [ATURLSessionInstrumentation enableDurationBreakdownWith:config instanceName:instanceName];
    [ATURLSessionInstrumentation disableWithDelegateClass:[MockDelegate class] instanceName:instanceName];
}

#pragma clang diagnostic pop

@end
