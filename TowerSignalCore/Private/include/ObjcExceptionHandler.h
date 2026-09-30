/*
* Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
* This product includes software developed at TowerSignal (https://www.towersignal.com/).
* Copyright 2026-Present TowerSignal, Inc.
*/

// ATCHG: TowerSignal SDK migration - renamed the `__dd_private_*` ObjC symbols to `__towersignal_private_*`;
// rebranded the licence header.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface __towersignal_private_ObjcExceptionHandler : NSObject

+ (BOOL)catchException:(void(NS_NOESCAPE ^)(void))tryBlock error:(__autoreleasing NSError **)error
    NS_SWIFT_NAME(rethrow(_:));

@end

NS_ASSUME_NONNULL_END
