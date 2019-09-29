import XCTest

extension SKClientTests {
    static let __allTests = [
        ("testMemberJoinedChannel", testMemberJoinedChannel),
        ("testMemberLeftChannel", testMemberLeftChannel),
    ]
}

extension SKCoreTests {
    static let __allTests = [
        ("testChannel", testChannel),
        ("testConversation", testConversation),
        ("testEvents", testEvents),
        ("testFile", testFile),
        ("testGroup", testGroup),
        ("testIm", testIm),
        ("testMpim", testMpim),
        ("testUser", testUser),
        ("testUserGroup", testUserGroup),
        ("testActionCodable", testActionCodable),
        ("testAttachmentFieldCodable", testAttachmentFieldCodable),
        ("testCustomProfileFieldCodable", testCustomProfileFieldCodable),
        ("testDoNotDisturbStatusCodable", testDoNotDisturbStatusCodable),
        ("testEditedCodable", testEditedCodable),
        ("testReplyCodable", testReplyCodable),
        ("testTeamIconCodable", testTeamIconCodable),
        ("testTopicCodable", testTopicCodable),
    ]
}

