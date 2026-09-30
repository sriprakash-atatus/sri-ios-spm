/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at TowerSignal (https://www.towersignal.com/).
 * Copyright 2026-Present TowerSignal, Inc.
 */

// ATCHG: TowerSignal SDK migration - renamed `dd*` types to `TowerSignal*`; renamed the `DD` symbol prefix to
// `AT`; rebranded the `dd` name to `TowerSignal` in comments and docs; rebranded the licence header.

import Foundation

private enum ATCFMessageID {
    static let setCustomTags: Int32 = 0x1111
    static let enableRUM: Int32 = 0x2222
    static let forceFlush: Int32 = 0x3333
}

internal class CITestIntegration {
    /// Current and active integration with CIApp.
    /// `nil` if the integration is not enabled.
    static let active: CITestIntegration? = CITestIntegration()
    /// RUMCITest model to be attached to events, it contains the CI context
    let testExecutionId: String
    /// Tag that must be added to spans and headers when running inside a CIApp test
    let origin = "ciapp-test"
    // UUID for test process message channel
    private let messageChannelUUID: String?

    private init?(processInfo: ProcessInfo = .processInfo) {
        guard let testID = processInfo.environment["CI_VISIBILITY_TEST_EXECUTION_ID"] else {
            return nil
        }
        self.testExecutionId = testID
        self.messageChannelUUID = processInfo.environment["CI_VISIBILITY_MESSAGE_CHANNEL_UUID"]
    }

    /// Entry point for running all the tasks needed for CIApp integration
    func startIntegration() {
        startMessageListener()
        notifyRUMSession()
    }

    /// Notifies the CIApp framework that a RUM session is being started. It sends a message to a CFMessagePort that is
    /// created in the CIApp framework
    private func notifyRUMSession() {
        let timeout: CFTimeInterval = 1.0

        guard let remotePort = CFMessagePortCreateRemote(
            nil, messagePortId(name: "TowerSignalTestingPort")
        ) else {
            return
        }
        CFMessagePortSendRequest(
            remotePort,
            ATCFMessageID.enableRUM, // Message ID for notifying the test that rum is enabled
            nil,
            timeout,
            timeout,
            nil,
            nil
        )
    }

    /// Creates a CFMessagePort that is used by the CIApp framework to notify that a test is going to finish, so all
    /// information must be flushed to the backend. It uses a non public API `internalFlushAndDeinitialize()`
    private func startMessageListener() {
        func attributeCallback(port: CFMessagePort?, msgid: Int32, data: CFData?, info: UnsafeMutableRawPointer?) -> Unmanaged<CFData>? {
            switch msgid {
            case ATCFMessageID.forceFlush:
                TowerSignal.internalFlushAndDeinitialize()
            default:
                break
            }
            return nil
        }

        guard let port = CFMessagePortCreateLocal(
            nil, messagePortId(name: "TowerSignalRUMTestingPort"), attributeCallback, nil, nil
        ) else {
            return
        }
        let runLoopSource = CFMessagePortCreateRunLoopSource(nil, port, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, CFRunLoopMode.commonModes)
    }

    /// Creates a ID for message port. If UUID is provided joins name with UUID.
    /// Fallbacks to name if UUID is nil for backward compatibility
    private func messagePortId(name: String) -> CFString {
        (messageChannelUUID.map { "\(name)-\($0)" } ?? name) as CFString
    }
}
