//
//  AuthorizeRequest.swift
//  SKServer
//
//  Created by Peter Zignego on 3/14/19.
//

import SmokeOperations

// Sent to the Slack app's specified `redirect_uri` after a user authorizes the app
public struct AuthorizeRequest: ValidatableCodable, Equatable {
    let code: String
    let state: String?

    public func validate() throws {

    }
}
