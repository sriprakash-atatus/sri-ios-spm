/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; renamed
// `dd*` types to `TowerSignal*`; renamed the `DD` symbol prefix to `AT`; renamed `dd*` members to `at*`;
// renamed the build `variant` to `appName`; renamed the `ddsource` / `ddtags` query parameters to
// `towersignal_source` / `towersignaltags`; rebranded the licence header.

import TowerSignalInternal
import TestUtilities
import XCTest

final class TowerSignalContextTests: XCTestCase {
    // MARK: - Test towersignalTags

    func testTowerSignalDDTags() throws {
        // Given
        let service: String = .mockRandom()
        let env: String = .mockRandom()
        let version: String = .mockRandom()
        let sdkVersion: String = .mockRandom()
        let appName: String = .mockRandom()
        let towersignalContext: TowerSignalContext = .mockWith(
            service: service,
            env: env,
            version: version,
            appName: appName,
            sdkVersion: sdkVersion
        )

        // Then
        let atTagsArray = towersignalContext.atTags.split(separator: ",")

        let atTags = atTagsArray.reduce(into: [:]) {
            let item = $1.split(separator: ":")
            $0[String(item[0])] = String(item[1])
        }

        XCTAssertEqual(atTags["service"] as! String, service)
        XCTAssertEqual(atTags["env"] as! String, env)
        XCTAssertEqual(atTags["version"] as! String, version)
        XCTAssertEqual(atTags["sdk_version"] as! String, sdkVersion)
        XCTAssertEqual(atTags["appName"] as! String, appName)
    }

    func testTowerSignalSanitizedDDTags() throws {
        // Given
        let service = "service:with:colons"
        let env = "prod,dev"
        let version = "1,2,3"
        let sdkVersion = "3,2,1"
        let appName = "appName,with,commas:"
        let towersignalContext: TowerSignalContext = .mockWith(
            service: service,
            env: env,
            version: version,
            appName: appName,
            sdkVersion: sdkVersion
        )

        // Then
        let atTagsArray = towersignalContext.atTags.split(separator: ",")

        let atTags = atTagsArray.reduce(into: [:]) {
            let item = $1.split(separator: ":")
            $0[String(item[0])] = String(item[1])
        }

        XCTAssertEqual(atTags["service"] as! String, "servicewithcolons")
        XCTAssertEqual(atTags["env"] as! String, "proddev")
        XCTAssertEqual(atTags["version"] as! String, "123")
        XCTAssertEqual(atTags["sdk_version"] as! String, "321")
        XCTAssertEqual(atTags["appName"] as! String, "variantwithcommas")
    }

    func testTowerSignalDDTagsWithoutVariant() throws {
        // Given
        let service: String = .mockRandom()
        let env: String = .mockRandom()
        let version: String = .mockRandom()
        let sdkVersion: String = .mockRandom()
        let towersignalContext: TowerSignalContext = .mockWith(
            service: service,
            env: env,
            version: version,
            appName: nil,
            sdkVersion: sdkVersion
        )

        // Then
        let atTagsArray = towersignalContext.atTags.split(separator: ",")

        let atTags = atTagsArray.reduce(into: [:]) {
            let item = $1.split(separator: ":")
            $0[String(item[0])] = String(item[1])
        }

        XCTAssertEqual(atTags["service"] as! String, service)
        XCTAssertEqual(atTags["env"] as! String, env)
        XCTAssertEqual(atTags["version"] as! String, version)
        XCTAssertEqual(atTags["sdk_version"] as! String, sdkVersion)
        XCTAssertNil(atTags["appName"])
    }

    // MARK: - atTags caching

    func testDDTagsUpdatesWhenVersionChanges() throws {
        // Given
        var context: TowerSignalContext = .mockWith(version: "1.0.0")
        let originalDDTags = context.atTags
        XCTAssertTrue(originalDDTags.contains("version:1.0.0"))

        // When
        context.version = "2.0.0"

        // Then
        XCTAssertTrue(context.atTags.contains("version:2.0.0"))
        XCTAssertFalse(context.atTags.contains("version:1.0.0"))
        XCTAssertNotEqual(context.atTags, originalDDTags)
    }

    func testDDTagsSanitizesVersionOnUpdate() throws {
        // Given
        var context: TowerSignalContext = .mockWith(version: "1.0.0")

        // When
        context.version = "2,0:0"

        // Then
        XCTAssertEqual(context.version, "200")
        XCTAssertTrue(context.atTags.contains("version:200"))
    }

    // MARK: - ATTag.merge

    func testMergeDDTags_whenOtherTagsIsNilOrEmpty_itReturnsNativeTagsUnchanged() {
        let nativeTags = "service:app,version:1.0.0,sdk_version:5.0.0,env:prod"

        XCTAssertEqual(ATTag.merge(nativeTags, with: nil), nativeTags)
        XCTAssertEqual(ATTag.merge(nativeTags, with: ""), nativeTags)
    }

    func testMergeDDTags_whenOtherTagsHasNoOverlappingKeys_itAppendsThem() {
        let merged = ATTag.merge(
            "service:app,version:1.0.0,sdk_version:5.0.0,env:prod",
            with: "browser_sdk_version:3.6.13"
        )

        XCTAssertEqual(merged, "browser_sdk_version:3.6.13,env:prod,sdk_version:5.0.0,service:app,version:1.0.0")
    }

    func testMergeDDTags_whenOtherTagsHasOverlappingKeys_itOverridesNativeValuesInPlace() {
        let merged = ATTag.merge(
            "service:app,version:1.0.0,sdk_version:5.0.0,env:prod",
            with: "sdk_version:3.6.13,browser_sdk_version:3.6.13"
        )

        XCTAssertEqual(merged, "browser_sdk_version:3.6.13,env:prod,sdk_version:3.6.13,service:app,version:1.0.0")
    }

    func testMergeDDTags_itIgnoresPairsWithoutAColon() {
        let merged = ATTag.merge(
            "service:app,version:1.0.0",
            with: "malformed,env:prod"
        )

        XCTAssertEqual(merged, "env:prod,service:app,version:1.0.0")
    }
}
