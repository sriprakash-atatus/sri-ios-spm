/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - rebranded the licence header.

#import "CrashReportingObjcHelpers.h"

@implementation CrashReportingObjcHelpers

- (void)throwUncaughtNSException {
    id object = [NSObject new];
    [(NSDictionary*)object objectForKey:@"foo"];
}

- (void)dereferenceNullPointer {
    int* pointer = NULL;
    *pointer = 1;
}

@end
