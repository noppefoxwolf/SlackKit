//
//  RTMOperation.swift
//  SlackKit
//
//  Created by Peter Zignego on 3/19/19.
//

import Foundation

public struct RTMOperation {
    public typealias RTMEvent = (EventType, (Event) -> ())
    public let event: RTMEvent

    public init(event: RTMEvent) {
        self.event = event
    }
}
