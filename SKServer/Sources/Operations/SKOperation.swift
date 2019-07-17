//
//  SKOperation.swift
//  SKServer
//
//  Created by Peter Zignego on 3/12/19.
//

import NIOHTTP1

public enum OperationType {
    case oAuth
    case slashCommand
}

public protocol SKOperation {
    var type: OperationType { get }
    var route: String { get }
    var httpMethod: HTTPMethod { get }
    var asynchronous: Bool { get }
}
