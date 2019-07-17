//
//  OAuthMiddleware.swift
//  SKServer
//
//  Created by Peter Zignego on 3/14/19.
//

import Foundation
import SKCore
import SKWebAPI
import NIOHTTP1
import SmokeOperations
import SmokeOperationsHTTP1

protocol OAuthResponder {
    // Blocking return SKResponse
    func sync(input: AuthorizeRequest, context: SlackKitServer) throws
}

struct OAuth: SKOperation {
    let type: OperationType = .oAuth
    let httpMethod: HTTPMethod = .GET
    let asynchronous: Bool = false
    let route: String = "/oauth"
    let config: AppConfig
    let authResponse: ((OAuthResponse) -> ())?

    init(config: AppConfig, response: ((OAuthResponse) -> ())?) {
        self.config = config
        self.authResponse = response
    }

    internal func addHandlerWithHandler(_ handler: inout HandlerSelector) {
        handler.addHandlerForUri("/oauth",
                                 httpMethod: httpMethod,
                                 operation: sync,
                                 allowedErrors: ErrorResponse.allowedErrors,
                                 inputLocation: .query)
    }
}

extension OAuth: OAuthResponder {
    func sync(input: AuthorizeRequest, context: SlackKitServer) throws {
        try verifyState(input.state)
        let json = try WebAPI.oauthAccess(clientID: config.clientID, clientSecret: config.clientSecret, code: input.code, redirectURI: config.redirectURI)
        guard let response = OAuthResponse(response: json) else {
            throw SKError.clientJSONError
        }
        authResponse?(response)
    }

    // MARK: Helpers

    func verifyState(_ state: String?) throws {
        if let state = state, let configState = config.state, configState != state {
            throw ErrorResponse.internalServerError
        }
    }
}
