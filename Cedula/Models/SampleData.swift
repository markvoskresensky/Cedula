//
//  SampleData.swift
//  Cedula
//
//  Created by Marko on 17.06.2026.
//

import Foundation

enum SampleData {
    static let currentUser = User(id: "me", displayName: "Me", avatarName: nil)

    static let alice = User(id: "alice", displayName: "Alice Johnson", avatarName: nil)
    static let bob = User(id: "bob", displayName: "Bob Smith", avatarName: nil)
    static let carol = User(id: "carol", displayName: "Carol Williams", avatarName: nil)

    static let conversations: [Conversation] = [
        Conversation(
            id: "c1",
            title: alice.displayName,
            participantIDs: [currentUser.id, alice.id],
            lastMessageText: "See you tomorrow!",
            lastMessageDate: .now.addingTimeInterval(-300),
            unreadCount: 2
        ),
        Conversation(
            id: "c2",
            title: bob.displayName,
            participantIDs: [currentUser.id, bob.id],
            lastMessageText: "Thanks 🙌",
            lastMessageDate: .now.addingTimeInterval(-3600),
            unreadCount: 0
        ),
        Conversation(
            id: "c3",
            title: carol.displayName,
            participantIDs: [currentUser.id, carol.id],
            lastMessageText: "Let's catch up soon",
            lastMessageDate: .now.addingTimeInterval(-86_400),
            unreadCount: 0
        ),
    ]

    static let messagesByConversation: [String: [Message]] = [
        "c1": [
            Message(id: "m1", conversationID: "c1", senderID: alice.id, text: "Hey! How are you?", sentAt: .now.addingTimeInterval(-1_200), status: .read),
            Message(id: "m2", conversationID: "c1", senderID: currentUser.id, text: "Doing great, you?", sentAt: .now.addingTimeInterval(-900), status: .read),
            Message(id: "m3", conversationID: "c1", senderID: alice.id, text: "See you tomorrow!", sentAt: .now.addingTimeInterval(-300), status: .delivered),
        ],
        "c2": [
            Message(id: "m4", conversationID: "c2", senderID: currentUser.id, text: "Sent the files over", sentAt: .now.addingTimeInterval(-4_000), status: .read),
            Message(id: "m5", conversationID: "c2", senderID: bob.id, text: "Thanks 🙌", sentAt: .now.addingTimeInterval(-3_600), status: .read),
        ],
        "c3": [
            Message(id: "m6", conversationID: "c3", senderID: carol.id, text: "Let's catch up soon", sentAt: .now.addingTimeInterval(-86_400), status: .read),
        ],
    ]
}
