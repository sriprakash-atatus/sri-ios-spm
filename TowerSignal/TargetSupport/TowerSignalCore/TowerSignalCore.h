/*
* Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
* This product includes software developed at TowerSignal (https://www.towersignal.com/).
* Copyright 2026-Present TowerSignal, Inc.
*/

// ATCHG: TowerSignal SDK migration - renamed `dd*` types to `TowerSignal*`; rebranded the `dd` name to
// `TowerSignal` in comments and docs; rebranded the licence header.

#import <Foundation/Foundation.h>

//! Project version number for TowerSignal.
FOUNDATION_EXPORT double TowerSignalVersionNumber;

//! Project version string for TowerSignal.
FOUNDATION_EXPORT const unsigned char TowerSignalVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <TowerSignal/PublicHeader.h>

#import "ObjcAppLaunchHandler.h"
#import "ObjcExceptionHandler.h"
