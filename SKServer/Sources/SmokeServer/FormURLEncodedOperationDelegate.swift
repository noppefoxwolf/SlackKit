//
//  FormURLEncodedHTTP1OperationDelegate.swift
//  SKServer
//
//  Created by Peter Zignego on 3/8/19.
//

import Foundation
import SmokeOperations
import SmokeOperationsHTTP1
import SmokeHTTP1
import LoggerAPI
import HTTPPathCoding
import HTTPHeadersCoding
import QueryCoding
import ShapeCoding

internal struct MimeTypes {
    static let formURLEncoded = "application/x-www-form-urlencoded"
}

/**
 Struct conforming to the OperationDelegate protocol that handles operations from HTTP1 requests with application/x-www-form-urlencoded request bodies and JSON response payloads.
 */
public struct FormURLEncodedOperationDelegate: HTTP1OperationDelegate {

    let jsonResponseOperationDelegate = JSONPayloadHTTP1OperationDelegate()

    public init() {

    }

    // MARK: - Request

    public func getInputForOperation<InputType: OperationHTTP1InputProtocol>(requestHead: SmokeHTTP1RequestHead,
                                                                             body: Data?) throws -> InputType {

        func queryDecodableProvider() throws -> InputType.QueryType {
            return try QueryDecoder().decode(InputType.QueryType.self,
                                             from: requestHead.query)
        }

        func pathDecodableProvider() throws -> InputType.PathType {
            return try HTTPPathDecoder().decode(InputType.PathType.self,
                                                fromShape: requestHead.pathShape)
        }

        func bodyDecodableProvider() throws -> InputType.BodyType {
            if let body = body, let bodyString = String(data: body, encoding: .utf8) {
                return try QueryDecoder().decode(InputType.BodyType.self,
                                                 from: bodyString)
            } else {
                throw SmokeOperationsError.validationError(reason: "Input body expected; none found.")
            }
        }

        func headersDecodableProvider() throws -> InputType.HeadersType {
            let headers: [(String, String?)] =
                requestHead.httpRequestHead.headers.map { header in
                    return (header.name, header.value)
            }
            return try HTTPHeadersDecoder().decode(InputType.HeadersType.self,
                                                   from: headers)
        }

        return try InputType.compose(queryDecodableProvider: queryDecodableProvider,
                                     pathDecodableProvider: pathDecodableProvider,
                                     bodyDecodableProvider: bodyDecodableProvider,
                                     headersDecodableProvider: headersDecodableProvider)
    }

    public func getInputForOperation<InputType>(requestHead: SmokeHTTP1RequestHead,
                                                body: Data?,
                                                location: OperationInputHTTPLocation) throws -> InputType where InputType: Decodable {
        switch location {
        case .body:
            let wrappedInput: BodyOperationHTTPInput<InputType> =
                try getInputForOperation(requestHead: requestHead, body: body)

            return wrappedInput.body
        case .query:
            let wrappedInput: QueryOperationHTTPInput<InputType> =
                try getInputForOperation(requestHead: requestHead, body: body)

            return wrappedInput.query
        case .path:
            let wrappedInput: PathOperationHTTPInput<InputType> =
                try getInputForOperation(requestHead: requestHead, body: body)

            return wrappedInput.path
        case .headers:
            let wrappedInput: HeadersOperationHTTPInput<InputType> =
                try getInputForOperation(requestHead: requestHead, body: body)

            return wrappedInput.headers
        }
    }

    // MARK: - Response

    public func handleResponseForOperation<OutputType>(requestHead: SmokeHTTP1RequestHead, output: OutputType,
                                                       responseHandler: HTTP1ResponseHandler) where OutputType: OperationHTTP1OutputProtocol {
        jsonResponseOperationDelegate.handleResponseForOperation(requestHead: requestHead, output: output, responseHandler: responseHandler)
    }

    public func handleResponseForOperation<OutputType>(
        requestHead: SmokeHTTP1RequestHead,
        location: OperationOutputHTTPLocation,
        output: OutputType,
        responseHandler: HTTP1ResponseHandler) where OutputType: Encodable {
        jsonResponseOperationDelegate.handleResponseForOperation(requestHead: requestHead, location: location, output: output, responseHandler: responseHandler)
    }

    public func handleResponseForOperationWithNoOutput(requestHead: SmokeHTTP1RequestHead,
                                                       responseHandler: HTTP1ResponseHandler) {
        jsonResponseOperationDelegate.handleResponseForOperationWithNoOutput(requestHead: requestHead, responseHandler: responseHandler)
    }

    public func handleResponseForOperationFailure(requestHead: SmokeHTTP1RequestHead,
                                                  operationFailure: OperationFailure,
                                                  responseHandler: HTTP1ResponseHandler) {
        jsonResponseOperationDelegate.handleResponseForOperationFailure(requestHead: requestHead, operationFailure: operationFailure, responseHandler: responseHandler)
    }

    public func handleResponseForInternalServerError(requestHead: SmokeHTTP1RequestHead,
                                                     responseHandler: HTTP1ResponseHandler) {
        jsonResponseOperationDelegate.handleResponseForInternalServerError(requestHead: requestHead, responseHandler: responseHandler)
    }

    public func handleResponseForInvalidOperation(requestHead: SmokeHTTP1RequestHead,
                                                  message: String, responseHandler: HTTP1ResponseHandler) {
        jsonResponseOperationDelegate.handleResponseForInvalidOperation(requestHead: requestHead, message: message, responseHandler: responseHandler)
    }

    public func handleResponseForDecodingError(requestHead: SmokeHTTP1RequestHead,
                                               message: String, responseHandler: HTTP1ResponseHandler) {
        jsonResponseOperationDelegate.handleResponseForDecodingError(requestHead: requestHead, message: message, responseHandler: responseHandler)
    }

    public func handleResponseForValidationError(requestHead: SmokeHTTP1RequestHead,
                                                 message: String?, responseHandler: HTTP1ResponseHandler) {
        handleError(code: 400, reason: "ValidationError", message: message, responseHandler: responseHandler)
    }

    internal func handleError(code: Int,
                              reason: String,
                              message: String?,
                              responseHandler: HTTP1ResponseHandler) {
        let errorResult = SmokeOperationsErrorPayload(errorMessage: message)
        let encodedError = JSONEncoder.encodePayload(payload: errorResult,
                                                     reason: reason)

        let body = (contentType: MimeTypes.formURLEncoded, data: encodedError)
        let responseComponents = HTTP1ServerResponseComponents(additionalHeaders: [], body: body)

        responseHandler.complete(status: .custom(code: UInt(code), reasonPhrase: reason),
                                 responseComponents: responseComponents)
    }
}
