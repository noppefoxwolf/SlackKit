//
//  SlashCommandRequest.swift
//  SKServer
//
//  Created by Peter Zignego on 3/7/19.
//

//token=gIkuvaNzQIHg97ATvDxqgjtO
//&team_id=T0001
//&team_domain=example
//&enterprise_id=E0001
//&enterprise_name=Globular%20Construct%20Inc
//&channel_id=C2147483705
//&channel_name=test
//&user_id=U2147483697
//&user_name=Steve
//&command=/weather
//&text=94070
//&response_url=https://hooks.slack.com/commands/1234/5678
//&trigger_id=13345224609.738474920.8088930838d88f008e0

public struct SlashCommandRequest: SlackAppRequest {
    let token: String
    let team_id: String
    let team_domain: String
    let channel_id: String
    let channel_name: String
    let user_id: String
    let user_name: String
    let command: String
    let text: String
    let response_url: String
    let ssl_check: Bool?

    public func validate() throws {}
}
