/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

import Foundation
import SwiftUI
#if canImport(TowerSignalCore)
import TowerSignalCore
#endif
#if canImport(TowerSignalRUM)
import TowerSignalRUM
#endif
#if canImport(TowerSignalLogs)
import TowerSignalLogs
#endif
#if canImport(TowerSignalTrace)
import TowerSignalTrace
#endif
#if canImport(TowerSignalCrashReporting)
import TowerSignalCrashReporting
#endif
#if canImport(TowerSignalSessionReplay)
import TowerSignalSessionReplay
#endif

enum Telemetry {
    private static let configFileName = "TowerSignalConfig"

    static func start() {
        #if canImport(TowerSignalCore)
        let licenseKey = value(for: "TowerSignalLicenseKey", environment: "TOWERSIGNAL_LICENSE_KEY")
            ?? "lic_apm_3c890780dd3a4acd97fab9ce6eb5b917"
        let environment = value(for: "TowerSignalEnvironment", environment: "TOWERSIGNAL_ENV") ?? "demo"
        let serverUrl = value(for: "TowerSignalServerURL", environment: "TOWERSIGNAL_SERVER_URL") ?? "http://127.0.0.1:8088"
        let appName = value(for: "TowerSignalAppName", environment: "TOWERSIGNAL_APP_NAME")
            ?? value(for: "TowerSignalServiceName", environment: "TOWERSIGNAL_SERVICE_NAME")
            ?? "FlipShop"
        let service = value(for: "TowerSignalServiceName", environment: "TOWERSIGNAL_SERVICE_NAME") ?? appName
        let appID = value(for: "TowerSignalApplicationID", environment: "TOWERSIGNAL_APPLICATION_ID") ?? appName

        let configuration = TowerSignal.Configuration(
            licenseKey: licenseKey,
            env: environment,
            serverUrl: serverUrl,
            service: service,
            batchSize: .small,
            uploadFrequency: .frequent
        )
        TowerSignal.initialize(with: configuration, trackingConsent: .granted)
        TowerSignal.verbosityLevel = .debug

        let tracingHosts: Set<String> = [
            "127.0.0.1",
            "localhost",
            "demo.towersignal.com"
        ]

        #if canImport(TowerSignalRUM)
        RUM.enable(
            with: RUM.Configuration(
                applicationID: appID,
                uiKitViewsPredicate: DefaultUIKitRUMViewsPredicate(),
                uiKitActionsPredicate: DefaultUIKitRUMActionsPredicate(),
                swiftUIViewsPredicate: DefaultSwiftUIRUMViewsPredicate(),
                swiftUIActionsPredicate: DefaultSwiftUIRUMActionsPredicate(isLegacyDetectionEnabled: true),
                urlSessionTracking: .init(
                    firstPartyHostsTracing: .trace(
                        hosts: tracingHosts,
                        sampleRate: 100,
                        traceControlInjection: .all
                    )
                )
            )
        )
        RUMMonitor.shared().debug = true
        #endif

        #if canImport(TowerSignalLogs)
        Logs.enable(with: Logs.Configuration())
        let logger = Logger.create(with: Logger.Configuration(name: "flipshop", networkInfoEnabled: true))
        logger.info("FlipShop initialized with TowerSignal SDK", attributes: ["env": environment, "server": serverUrl])
        #endif

        #if canImport(TowerSignalTrace)
        var traceConfig = Trace.Configuration(
            service: service,
            networkInfoEnabled: true
        )
        traceConfig.urlSessionTracking = .init(
            firstPartyHostsTracing: .trace(
                hosts: tracingHosts,
                sampleRate: 100,
                traceControlInjection: .all
            )
        )
        Trace.enable(with: traceConfig)
        #endif

        #if canImport(TowerSignalCrashReporting)
        CrashReporting.enable()
        #endif

        #if canImport(TowerSignalSessionReplay)
        // Record all text, inputs, photos, and taps without masking the UI.
        SessionReplay.enable(
            with: SessionReplay.Configuration(
                replaySampleRate: 100,
                textAndInputPrivacyLevel: .maskSensitiveInputs,
                imagePrivacyLevel: .maskNone,
                touchPrivacyLevel: .show,
                featureFlags: [
                    .swiftui: true
                ]
            )
        )
        #endif

        // Trigger distributed trace sample calls (GET, POST, PUT, DELETE, PATCH)
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            sendSampleDistributedTraces(serverUrl: serverUrl, service: service)
        }
        #endif
    }

    static func sendSampleDistributedTraces(serverUrl: String, service: String) {
        #if canImport(TowerSignalTrace)
        // 1. Manual Span: simulate a distributed backend operation
        let tracer = Tracer.shared()
        let span = tracer.startSpan(operationName: "order.checkout.distributed")
        span.setTag(key: "order.id", value: "ORD-98231")
        span.setTag(key: "payment.method", value: "credit_card")
        span.setTag(key: "customer.tier", value: "vip")
        span.setTag(key: "service.name", value: service)
        span.finish()
        #endif

        // 2. 5 Distributed Tracing Network Calls: GET, POST, PUT, DELETE, PATCH
        let session = URLSession.shared

        // 1) GET /api/products
        if let url = URL(string: "\(serverUrl)/api/products") {
            var req = URLRequest(url: url)
            req.httpMethod = "GET"
            session.dataTask(with: req) { _, res, _ in
                print("✅ 1. GET /api/products -> \((res as? HTTPURLResponse)?.statusCode ?? 0)")
            }.resume()
        }

        // 2) POST /api/cart/items
        if let url = URL(string: "\(serverUrl)/api/cart/items") {
            var req = URLRequest(url: url)
            req.httpMethod = "POST"
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let postBody = ["productId": "prod_101", "name": "Wireless Noise Cancelling Headphones", "quantity": 1, "price": 149.99] as [String: Any]
            req.httpBody = try? JSONSerialization.data(withJSONObject: postBody)
            session.dataTask(with: req) { _, res, _ in
                print("✅ 2. POST /api/cart/items -> \((res as? HTTPURLResponse)?.statusCode ?? 0)")
            }.resume()
        }

        // 3) PUT /api/cart/items/prod_101
        if let url = URL(string: "\(serverUrl)/api/cart/items/prod_101") {
            var req = URLRequest(url: url)
            req.httpMethod = "PUT"
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let putBody = ["productId": "prod_101", "quantity": 3, "updatedAt": ISO8601DateFormatter().string(from: Date())] as [String: Any]
            req.httpBody = try? JSONSerialization.data(withJSONObject: putBody)
            session.dataTask(with: req) { _, res, _ in
                print("✅ 3. PUT /api/cart/items/prod_101 -> \((res as? HTTPURLResponse)?.statusCode ?? 0)")
            }.resume()
        }

        // 4) DELETE /api/cart/items/prod_101
        if let url = URL(string: "\(serverUrl)/api/cart/items/prod_101") {
            var req = URLRequest(url: url)
            req.httpMethod = "DELETE"
            session.dataTask(with: req) { _, res, _ in
                print("✅ 4. DELETE /api/cart/items/prod_101 -> \((res as? HTTPURLResponse)?.statusCode ?? 0)")
            }.resume()
        }

        // 5) PATCH /api/user/preferences
        if let url = URL(string: "\(serverUrl)/api/user/preferences") {
            var req = URLRequest(url: url)
            req.httpMethod = "PATCH"
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let patchBody = ["currency": "INR", "darkMode": true, "pushNotifications": true] as [String: Any]
            req.httpBody = try? JSONSerialization.data(withJSONObject: patchBody)
            session.dataTask(with: req) { _, res, _ in
                print("✅ 5. PATCH /api/user/preferences -> \((res as? HTTPURLResponse)?.statusCode ?? 0)")
            }.resume()
        }
    }

    private static func value(for key: String, environment: String) -> String? {
        if let env = ProcessInfo.processInfo.environment[environment], !env.isEmpty {
            return env
        }
        guard let url = Bundle.main.url(forResource: configFileName, withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
              let value = plist[key] as? String,
              !value.isEmpty else {
            return nil
        }
        return value
    }
}
