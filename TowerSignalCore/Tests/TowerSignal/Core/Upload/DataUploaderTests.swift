/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddCore` -> `TowerSignalCore`, `ddInternal` ->
// `TowerSignalInternal`; renamed the `DD` symbol prefix to `AT`; renamed `dd*` members to `at*`; renamed the
// `DD-*` intake headers to their TowerSignal equivalents; rebranded the licence header.

import XCTest
import TowerSignalInternal
import TestUtilities
@testable import TowerSignalCore

class DataUploaderTests: XCTestCase {
    // swiftlint:disable opening_brace
    func testGivenValidRequest_whenUploadCompletesWithStatusCode_itReturnsUploadStatus() throws {
        // Given
        let randomResponse: HTTPURLResponse = .mockResponseWith(statusCode: (100...599).randomElement()!)
        let randomRequest: URLRequest = oneOf([
            { .mockWith(headers: [:]) },
            { .mockWith(headers: ["TOWERSIGNAL-REQUEST-ID": String.mockRandom()]) }
        ])

        let uploader = DataUploader(
            httpClient: HTTPClientMock(response: randomResponse),
            requestBuilder: FeatureRequestBuilderMock(request: randomRequest),
            featureName: .mockRandom()
        )

        // When
        let uploadStatus = try uploader.upload(
            events: .mockAny(),
            context: .mockAny(),
            previous: nil
        )

        // Then
        let expectedUploadStatus = DataUploadStatus(
            httpResponse: randomResponse,
            atRequestID: randomRequest.value(forHTTPHeaderField: "TOWERSIGNAL-REQUEST-ID"),
            attempt: 0
        )

        ATAssertReflectionEqual(uploadStatus, expectedUploadStatus)
    }
    // swiftlint:enable opening_brace

    func testGivenValidRequest_whenUploadCompletesWithError_itReturnsUploadStatus() throws {
        // Given
        let randomErrorDescription: String = .mockRandom()
        let randomError = NSError(domain: .mockRandom(), code: .mockRandom(), userInfo: [NSLocalizedDescriptionKey: randomErrorDescription])
        let randomRequest: URLRequest = .mockAny()

        let uploader = DataUploader(
            httpClient: HTTPClientMock(error: randomError),
            requestBuilder: FeatureRequestBuilderMock(request: randomRequest),
            featureName: .mockRandom()
        )

        // When
        let uploadStatus = try uploader.upload(
            events: .mockAny(),
            context: .mockAny(),
            previous: nil
        )

        // Then
        let expectedUploadStatus = DataUploadStatus(networkError: randomError, attempt: 0)

        ATAssertReflectionEqual(uploadStatus, expectedUploadStatus)
    }

    func testWhenRequestCannotBeCreated_itThrows() throws {
        // Given
        let error = ErrorMock()

        let uploader = DataUploader(
            httpClient: HTTPClientMock(),
            requestBuilder: FailingRequestBuilderMock(error: error),
            featureName: .mockRandom()
        )

        // When & Then
        XCTAssertThrowsError(try uploader.upload(events: .mockAny(), context: .mockAny(), previous: nil)) { error in
            XCTAssertTrue(error is ErrorMock)
        }
    }
}
