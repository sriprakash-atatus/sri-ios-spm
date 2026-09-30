/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddRUM` -> `TowerSignalRUM`; rebranded the licence
// header.

import XCTest
import TowerSignalRUM
import TestUtilities

#if !os(watchOS)

#if canImport(SwiftUI)
import SwiftUI
#endif

class UIKitRUMViewsPredicateTests: XCTestCase {
    func testGivenDefaultPredicate_whenAskingForCustomSwiftViewController_itNamesTheViewByItsClassName() {
        // Given
        let predicate = DefaultUIKitRUMViewsPredicate()

        // When
        let customViewController = createMockView(viewControllerClassName: "CustomSwiftViewController")
        let rumView = predicate.rumView(for: customViewController)

        // Then
        XCTAssertEqual(rumView?.name, "CustomSwiftViewController")
        XCTAssertEqual(rumView?.path, "CustomSwiftViewController")
        XCTAssertTrue(rumView!.attributes.isEmpty)
    }

    func testGivenDefaultPredicate_whenAskingForCustomObjcViewController_itNamesTheViewByItsClassName() {
        // Given
        let predicate = DefaultUIKitRUMViewsPredicate()

        // When
        let customViewController = CustomObjcViewController()
        let rumView = predicate.rumView(for: customViewController)

        // Then
        XCTAssertEqual(rumView?.name, "CustomObjcViewController")
        XCTAssertEqual(rumView?.path, "CustomObjcViewController")
        XCTAssertTrue(rumView!.attributes.isEmpty)
    }

    func testGivenDefaultPredicate_whenAskingUIKitViewController_itReturnsNoView() {
        // Given
        let predicate = DefaultUIKitRUMViewsPredicate()

        // When
        let uiKitViewController = UIViewController()
        let rumView = predicate.rumView(for: uiKitViewController)

        // Then
        XCTAssertNil(rumView)
    }

#if canImport(SwiftUI)
    func testGivenDefaultPredicate_whenAskingSwiftUIViewController_itReturnsNoView() {
        guard #available(iOS 13, tvOS 13, *) else {
            return
        }
        // Given
        let predicate = DefaultUIKitRUMViewsPredicate()

        // When
        let swiftUIHostingController = UIHostingController<EmptyView>(rootView: EmptyView())
        let rumView = predicate.rumView(for: swiftUIHostingController)

        // Then
        XCTAssertNil(rumView)
    }
#endif
}

#endif
