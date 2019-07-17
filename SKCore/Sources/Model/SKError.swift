//
//  SKError.swift
//  SKCore
//
//  Created by Peter Zignego on 3/14/19.
//

import Foundation

public enum SKError: Error {
    case malformedRequestURL
    case clientNetworkError
    case clientJSONError
    case clientOAuthError
    // HTTP
    case tooManyRequests
    case unknownHTTPError
    // RTM
    case rtmConnectionError
}
