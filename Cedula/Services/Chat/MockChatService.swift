//
//  MockChatService.swift
//  Cedula
//
//  Created by Marko on 17.06.2026.
//

import Foundation

@MainActor
final class MockChatService: ChatService {
    private var messageStore: [String: [Message]]
    private var conversationStore: [Conversation]
    private var messageContinuations: [String: AsyncStream<[Message]>.Continuation] = [:]
    private var conversationContinuations: [AsyncStream<[Conversation]>.Continuation] = []

    init(messages: [String: [Message]]? = nil, conversations: [Conversation]? = nil) {
        messageStore = messages ?? SampleData.messagesByConversation
        conversationStore = conversations ?? SampleData.conversations
    }

    func conversations(for userID: String) -> AsyncStream<[Conversation]> {
        AsyncStream { continuation in
            continuation.yield(conversationStore)
            conversationContinuations.append(continuation)
        }
    }

    func messages(in conversationID: String) -> AsyncStream<[Message]> {
        AsyncStream { continuation in
            continuation.yield(messageStore[conversationID] ?? [])
            messageContinuations[conversationID] = continuation
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
        messageStore[conversationID, default: []].append(message)
        messageContinuations[conversationID]?.yield(messageStore[conversationID] ?? [])

        if let index = conversationStore.firstIndex(where: { $0.id == conversationID }) {
            conversationStore[index].lastMessageText = text
            conversationStore[index].lastMessageDate = message.sentAt
            broadcastConversations()
        }
    }

    private var typingStore: [String: Set<String>] = [:]
    private var typingSubscribers: [(conversationID: String, excluding: String, continuation: AsyncStream<Bool>.Continuation)] = []

    func setTyping(conversationID: String, userID: String, isTyping: Bool) async {
        var set = typingStore[conversationID] ?? []
        if isTyping { set.insert(userID) } else { set.remove(userID) }
        typingStore[conversationID] = set
        for subscriber in typingSubscribers where subscriber.conversationID == conversationID {
            subscriber.continuation.yield(set.contains { $0 != subscriber.excluding })
        }
    }

    func typing(in conversationID: String, excluding userID: String) -> AsyncStream<Bool> {
        AsyncStream { continuation in
            let set = typingStore[conversationID] ?? []
            continuation.yield(set.contains { $0 != userID })
            typingSubscribers.append((conversationID, userID, continuation))
        }
    }

    func markAsRead(conversationID: String, messageIDs: [String]) async {
        guard var messages = messageStore[conversationID] else { return }
        let ids = Set(messageIDs)
        var changed = false
        for index in messages.indices where ids.contains(messages[index].id) {
            messages[index].status = .read
            changed = true
        }
        guard changed else { return }
        messageStore[conversationID] = messages
        messageContinuations[conversationID]?.yield(messages)
    }

    func createConversation(participants: [User]) async throws -> String {
        let id = UUID().uuidString
        let conversation = Conversation(
            id: id,
            title: participants.last?.displayName ?? "Chat",
            participantIDs: participants.map(\.id),
            lastMessageText: "",
            lastMessageDate: .now,
            unreadCount: 0
        )
        conversationStore.insert(conversation, at: 0)
        broadcastConversations()
        return id
    }

    private func broadcastConversations() {
        for continuation in conversationContinuations {
            continuation.yield(conversationStore)
        }
    }
}
