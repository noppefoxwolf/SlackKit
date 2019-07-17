//
//  SlashCommand.swift
//  SKServer
//
//  Created by Peter Zignego on 3/10/19.
//

import Foundation
import NIOHTTP1
import SmokeOperations
import SmokeOperationsHTTP1
import SKWebAPI

protocol SlashCommandResponder {
    // Blocking return SKResponse
    func sync(input: SlashCommandRequest, context: SlackKitServer) throws -> SKResponse
    // Non-blocking return SKResponse
    func async(input: SlashCommandRequest, context: SlackKitServer, responseHandler: @escaping (SmokeResult<SKResponse>) -> ()) throws
}

public struct SlashCommand: SKOperation {
    public let type: OperationType = .slashCommand
    public let route: String
    public let token: String
    public let httpMethod: HTTPMethod
    public let asynchronous: Bool
    public let response: (SlashCommandRequest) -> SKResponse

    public init(route: String,
                token: String,
                httpMethod: HTTPMethod,
                asynchronous: Bool = false,
                response: @escaping (SlashCommandRequest) -> SKResponse) {
        self.route = route
        self.token = token
        self.httpMethod = httpMethod
        self.asynchronous = asynchronous
        self.response = response
    }

    internal func addHandlerWithHandler(_ handler: inout HandlerSelector) {
        let inputLocation: OperationInputHTTPLocation = httpMethod == .GET ? .query : .body
        switch operationClass {
        case .sync:
            handler.addHandlerForUri(route,
                                     httpMethod: httpMethod,
                                     operation: sync,
                                     allowedErrors: ErrorResponse.allowedErrors,
                                     inputLocation: inputLocation,
                                     outputLocation: .body,
                                     operationDelegate: FormURLEncodedOperationDelegate())
        case .async:
            handler.addHandlerForUri(route,
                                     httpMethod: httpMethod,
                                     operation: async,
                                     allowedErrors: ErrorResponse.allowedErrors,
                                     inputLocation: inputLocation,
                                     outputLocation: .body,
                                     operationDelegate: FormURLEncodedOperationDelegate())
        }
    }

    // MARK: - Operation class

    private enum OperationClass {
        case sync
        case async
    }

    private var operationClass: OperationClass {
        switch asynchronous {
        case true:
            return .async
        case false:
            return .sync
        }
    }
}

extension SlashCommand: SlashCommandResponder {
    func sync(input: SlashCommandRequest, context: SlackKitServer) throws -> SKResponse {
        try validateToken(input)

        return response(input)
    }

    func async(input: SlashCommandRequest, context: SlackKitServer, responseHandler: @escaping (SmokeResult<SKResponse>) -> ()) throws {
        try validateToken(input)

        let data = try JSONEncoder().encode(response(input))
        NetworkInterface().customRequest(input.response_url, data: data, success: { success in
            print(success)
        }) { error in
            print(error)
        }

        // Respond 200 OK and send the actual async response to the response_url
        responseHandler(.response(SKResponse.okResponse))
    }

    // MARK: - Helpers

    func validateToken(_ input: SlashCommandRequest) throws {
        guard token == input.token else {
            throw SmokeOperationsError.validationError(reason: "invalid token")
        }
    }
}
