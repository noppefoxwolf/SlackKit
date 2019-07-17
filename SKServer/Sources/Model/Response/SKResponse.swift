//
// SKResponse.swift
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
import SKCore
#endif
import SmokeOperations
import SmokeHTTPClient

public struct SKResponse: ValidatableCodable {

    let text: String
    let response_type: MessageResponseType
    let attachments: [Attachment]?

    public init(text: String, responseType: MessageResponseType = .inChannel, attachments: [Attachment]? = nil) {
        self.text = text
        self.response_type = responseType
        self.attachments = attachments
    }

    public func validate() throws {

    }
}

// MARK: - Convenience
extension SKResponse {
    static let okResponse = SKResponse(text: "")
}

public struct SKErrorResponse: ValidatableCodable {

    let text: String
    let response_type: MessageResponseType = .ephemeral

    public func validate() throws {
        guard !text.isEmpty else {
            throw SmokeOperationsError.validationError(reason: "SKErrorResponse text is empty")
        }
    }
}
