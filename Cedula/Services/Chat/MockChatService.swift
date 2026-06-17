//
//  MockChatService.swift
//  Cedula
//
//  Created by Marko on 17.06.2026.
//

import Foundation

@MainActor
final class MockChatService: ChatService {
    private var store: [String: [Message]]
    private var continuations: [String: AsyncStream<[Message]>.Continuation] = [:]

    init(seed: [String: [Message]] = SampleData.messagesByConversation) {
        store = seed
    }

    func loadConversations() async -> [Conversation] {
        SampleData.conversations
    }

    func messages(in conversationID: String) -> AsyncStream<[Message]> {
        AsyncStream { continuation in
            continuation.yield(store[conversationID] ?? [])
            continuations[conversationID] = continuation
        }
    }

    func send(text: String, to conversationID: String, from senderID: String) async throws {
        let message = Message(
            id: UUID().uuidString,
            conversationID: conversationID,
            senderID: senderID,
            text: text,
            sentAt: .now,
            status: .sent
        )
        store[conversationID, default: []].append(message)
        continuations[conversationID]?.yield(store[conversationID] ?? [])
    }
}
