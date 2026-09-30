/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed module imports `ddInternal` -> `TowerSignalInternal`; renamed
// `dd*` types to `TowerSignal*`; renamed `dd*` members to `at*`; renamed `clientToken` to `licenseKey`;
// renamed the `ddsource` / `ddtags` query parameters to `towersignal_source` / `towersignaltags`; rebranded the
// licence header.

import Foundation
import TowerSignalInternal

public class FeatureRequestBuilderMock: FeatureRequestBuilder {
    private let factory: (([Event], TowerSignalContext) throws -> URLRequest)

    public init(factory: @escaping (([Event], TowerSignalContext) throws -> URLRequest) = { _, _ in .mockAny() }) {
        self.factory = factory
    }

    public convenience init(request: URLRequest) {
        self.init(factory: { _, _ in request })
    }

    public func request(
        for events: [Event],
        with context: TowerSignalContext,
        execution: ExecutionContext
    ) throws -> URLRequest {
        return try factory(events, context)
    }
}

public  class FeatureRequestBuilderSpy: FeatureRequestBuilder {
    /// Stores the parameters passed to the `request(for:with:)` method.
    @ReadWriteLock
    public private(set) var requestParameters: [(events: [Event], context: TowerSignalContext)] = []

    /// A closure that is called when a request is about to be created in the `request(for:with:)` method.
    @ReadWriteLock
    public var onRequest: ((_ events: [Event], _ context: TowerSignalContext) -> Void)?

    public init() {}

    public func request(
        for events: [Event],
        with context: TowerSignalContext,
        execution: ExecutionContext
    ) throws -> URLRequest {
        requestParameters.append((events: events, context: context))
        onRequest?(events, context)
        return .mockAny()
    }
}

public struct FailingRequestBuilderMock: FeatureRequestBuilder {
    let error: Error

    public init(error: Error) {
        self.error = error
    }

    public func request(
        for events: [Event],
        with context: TowerSignalContext,
        execution: ExecutionContext
    ) throws -> URLRequest {
        throw error
    }
}

extension URLRequestBuilder.QueryItem: RandomMockable, AnyMockable {
    public static func mockRandom() -> Self {
        let all: [URLRequestBuilder.QueryItem] = [
            .towersignalSource(source: .mockRandom()),
            .towersignalTags(tags: .mockRandom()),
        ]
        return all.randomElement()!
    }

    public static func mockAny() -> Self {
        return .towersignalSource(source: .mockRandom(among: .alphanumerics))
    }
}

extension URLRequestBuilder.HTTPHeader: RandomMockable, AnyMockable {
    public static func mockRandom() -> Self {
        let all: [URLRequestBuilder.HTTPHeader] = [
            .contentTypeHeader(contentType: Bool.random() ? .applicationJSON : .textPlainUTF8),
            .userAgentHeader(
                appName: .mockRandom(among: .alphanumerics),
                appVersion: .mockRandom(among: .alphanumerics),
                device: .mockAny(),
                os: .mockAny()
            ),
            .atAPIKeyHeader(licenseKey: .mockRandom(among: .alphanumerics)),
            .atEVPOriginHeader(source: .mockRandom(among: .alphanumerics)),
            .atEVPOriginVersionHeader(sdkVersion: .mockRandom(among: .alphanumerics)),
            .atRequestIDHeader()
        ]
        return all.randomElement()!
    }

    public static func mockAny() -> Self {
        return .atEVPOriginVersionHeader(sdkVersion: "1.2.3")
    }
}

extension URLRequestBuilder: AnyMockable {
    public static func mockAny() -> Self {
        return mockWith()
    }

    public static func mockWith(
        url: URL = .mockAny(),
        queryItems: [QueryItem] = [],
        headers: [HTTPHeader] = []
    ) -> Self {
        return URLRequestBuilder(
            url: url,
            queryItems: queryItems,
            headers: headers
        )
    }
}
