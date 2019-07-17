//
// IncomingWebhook.swift
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

public struct IncomingWebhook: Codable {
    public let url: String
    public let channel: String
    public let configuration_url: String
    public let username: String?
    public let icon_emoji: String?
    public let icon_url: String?

    init?(webhook: [String: Any]?) {
        guard
            let url = webhook?["url"] as? String,
            let channel = webhook?["channel"] as? String,
            let configuration_url = webhook?["configuration_url"] as? String
        else {
            return nil
        }
        self.url = url
        self.channel = channel
        self.configuration_url = configuration_url
        username = webhook?["username"] as? String
        icon_emoji = webhook?["icon_emoji"] as? String
        icon_url = webhook?["icon_url"] as? String
    }
}
