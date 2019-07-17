//
// OAuthResponse.swift
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

#if !COCOAPODS
import SKCore
#endif
import SmokeOperations

//{
//    "access_token": "xoxp-XXXXXXXX-XXXXXXXX-XXXXX",
//    "scope": "incoming-webhook,commands,bot",
//    "team_name": "Team Installing Your Hook",
//    "team_id": "TXXXXXXXXX",
//    "incoming_webhook": {
//        "url": "https://hooks.slack.com/TXXXXX/BXXXXX/XXXXXXXXXX",
//        "channel": "#channel-it-will-post-to",
//        "configuration_url": "https://teamname.slack.com/services/BXXXXX"
//    },
//    "bot": {
//        "bot_user_id": "UTTTTTTTTTTR",
//        "bot_access_token": "xoxb-XXXXXXXXXXXX-TTTTTTTTTTTTTT"
//    }
//}

public struct OAuthResponse: ValidatableCodable {
    public let accessToken: String
    public let scope: [Scope]
    public let teamName: String
    public let teamID: String
    public let incomingWebhook: IncomingWebhook?
    public let bot: Bot?

    public func validate() throws {

    }

    init?(response: [String: Any]?) {
        guard
            let accessToken = response?["access_token"] as? String,
            let scope = (response?["scope"] as? String)?.components(separatedBy: ",").compactMap({ Scope(rawValue: $0) }),
            let teamName = response?["team_name"] as? String,
            let teamID = response?["team_id"] as? String
        else {
            return nil
        }
        self.accessToken = accessToken
        self.scope  = scope
        self.teamName = teamName
        self.teamID = teamID
        incomingWebhook = IncomingWebhook(webhook: response?["incoming_webhook"] as? [String: Any])
        bot = Bot(json: response?["bot"] as? [String: Any])
    }
}
