/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddTrace` -> `TowerSignalTrace`; rebranded the
// licence header.

#import "Runner-Swift.h"
#import "ObjcSendFirstPartyRequestsViewController.h"
@import TowerSignalTrace;

@interface ObjcSendFirstPartyRequestsViewController ()
@property URLSessionBaseScenario *testScenario;
@property NSURLSession *session;
@end

@implementation ObjcSendFirstPartyRequestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.testScenario = SwiftGlobals.currentTestScenario;

    self.session = [self.testScenario getURLSession];
    assert(self.testScenario != nil);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self callSuccessfulFirstPartyURL];
    [self callSuccessfulFirstPartyURLRequest];
    [self callBadFirstPartyURL];
}

- (void)callSuccessfulFirstPartyURL {
    NSURLSessionTask *task = [self.session dataTaskWithURL:self.testScenario.customGETResourceURL
                                         completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        assert(error == nil);
    }];
    [task resume];
}

- (void)callSuccessfulFirstPartyURLRequest {
    NSURLSessionTask *task = [self.session dataTaskWithRequest:self.testScenario.customPOSTRequest
                                             completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        assert(error == nil);
    }];
    [task resume];
}

- (void)callBadFirstPartyURL {
    NSURLSessionTask *task = [self.session dataTaskWithURL:self.testScenario.badResourceURL];
    [task resume];
}

@end
