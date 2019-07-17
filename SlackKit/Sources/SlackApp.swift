//
//  SlackApp.swift
//  SlackKit
//
//  Created by Peter Zignego on 3/19/19.
//

import Foundation
#if !COCOAPODS
@_exported import SKClient
@_exported import SKCore
@_exported import SKRTMAPI
@_exported import SKServer
@_exported import SKWebAPI
#endif

public struct SlackApp: RTMAdapter {

    var client: Client?
    var bot: SKRTMAPI?
    var webAPI: WebAPI?

    let operations: [RTMOperation]

    public init(operations: [RTMOperation], token: String, botToken: String?, options: RTMOptions = RTMOptions()) {
        self.operations = operations
        // Client
        addClient()
        // User
        addWebAPIAccessWithToken(token)
        // Bot User
        if let botToken = botToken {
            addRTMBotWithAPIToken(botToken, options: options)
        }
    }

    public mutating func addClient(_ client: Client = Client()) {
        self.client = client
    }

    public mutating func addWebAPIAccessWithToken(_ token: String) {
        webAPI = WebAPI(token: token)
    }

    public mutating func addRTMBotWithAPIToken(_ token: String, options: RTMOptions) {
        bot = SKRTMAPI(withAPIToken: token, options: options)
        bot?.adapter = self
        bot?.connect()
    }

    // MARK: - RTM Adapter

    public func initialSetup(json: [String: Any]) {
        client?.initialSetup(JSON: json)
    }

    public func notificationForEvent(_ event: Event, type: EventType) {
        executeCallbackForEvent(event, type: type)
    }

    public func connectionClosed(with error: Error) {

    }

    // MARK: - Callbacks

    private func executeCallbackForEvent(_ event: Event, type: EventType) {
        let ops = operations.filter { $0.event.0 == type }
        for op in ops {
            op.event.1(event)
        }
    }
}
