//
//  ErrorResponse.swift
//  SKServer
//
//  Created by Peter Zignego on 3/7/19.
//

public enum ErrorResponse: Error {
    case notFound
    case invalidToken
    case internalServerError
}

extension ErrorResponse: CustomStringConvertible {
    public var description: String {
        switch self {
        case .notFound:
            return "not found"
        case .internalServerError:
            return "internal server error"
        case .invalidToken:
            return "invalid token"
        }
    }
}

extension ErrorResponse {
    typealias ErrorType = (ErrorResponse, Int)
    var errorType: ErrorType {
        switch self {
        case .notFound:
            return (self, 404)
        case .internalServerError:
            return (self, 500)
        case .invalidToken:
            return (self, 400)
        }
    }

    static var allowedErrors: [ErrorType] {
        let values: [ErrorResponse] = [.notFound, .internalServerError, .invalidToken]
        return values.compactMap { $0.errorType }
    }
}
