/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddCore` -> `TowerSignalCore`, `ddInternal` ->
// `TowerSignalInternal`, `ddRUM` -> `TowerSignalRUM`; rebranded the licence header.

#if !os(watchOS) && canImport(SwiftUI)

import XCTest
import SwiftUI

@testable import TowerSignalRUM
@testable import TowerSignalCore
@testable import TowerSignalInternal

class CustomViewController: UIViewController {}

@available(iOS 13, tvOS 13, *)
final class TestView: View {
    var body = EmptyView()
}

class SwiftUIExtensionsTests: XCTestCase {
    func testSwiftUIViewTypeDescription() {
        guard #available(iOS 13, tvOS 13, *) else {
            return
        }

        let view = TestView().cornerRadius(8)
        XCTAssertEqual(view.typeDescription, "ModifiedContent<TestView, _ClipEffect<RoundedRectangle>>")
    }

    func testBundleIsSwiftUI() {
        guard #available(iOS 13, tvOS 13, *) else {
            return
        }

        // Given
        let someSwiftUITypes: [AnyClass] = [
            UIHostingController<AnyView>.self // The only class in SwiftUI
        ]

        let someNonSwiftUITypes: [AnyClass] = [
            TestView.self,
            UIViewController.self,
            OperationQueue.self,
            CustomViewController.self
        ]

        // Then
        someSwiftUITypes.forEach { XCTAssertTrue(Bundle(for: $0).dd.isSwiftUI) }
        someNonSwiftUITypes.forEach { XCTAssertFalse(Bundle(for: $0).dd.isSwiftUI) }
    }
}
#endif
