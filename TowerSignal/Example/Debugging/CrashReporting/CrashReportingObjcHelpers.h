/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - rebranded the licence header.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CrashReportingObjcHelpers : NSObject

- (void) throwUncaughtNSException;
- (void) dereferenceNullPointer;

@end

NS_ASSUME_NONNULL_END
