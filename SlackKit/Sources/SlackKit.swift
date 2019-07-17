//
// SlackKit.swift
//
// Copyright © 2017 Peter Zignego. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
#if !COCOAPODS
@_exported import SKClient
@_exported import SKCore
@_exported import SKRTMAPI
@_exported import SKServer
@_exported import SKWebAPI
#endif

public final class SlackKit {

    var server: SKServer?
    // teamId_authToken: SlackApp
    var apps: [String: SlackApp] = [:]

    public init() {}

    public init(app: AppConfig, operations: [SKOperation]) {
        addAppServer(operations: operations, app: app)
    }

    public func addServer(operations: [SKOperation]) {
        server = SKServer(operations: operations, app: nil, auth: nil)
    }

    public func addAppServer(operations: [SKOperation], app: AppConfig) {
        server = SKServer(operations: operations, app: app, auth: { [weak self] response in
            self?.authResponse(response)
        })
    }

    // MARK: OAuth

    func authResponse(_ response: OAuthResponse) {
        let appId = "\(response.teamID)_\(response.accessToken)"
        apps[appId] = SlackApp(operations: [], token: response.accessToken, botToken: response.bot?.bot_access_token)
    }
}
