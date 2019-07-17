//
//  SlackRequest.swift
//  SKServer
//
//  Created by Peter Zignego on 3/14/19.
//

import Foundation
import SmokeOperations

protocol SlackAppRequest: ValidatableCodable, Equatable {
    var token: String { get }
    var ssl_check: Bool? { get }
}
