//
//  ChatService.swift
//  Cedula
//
//  Created by Marko on 17.06.2026.
//

import Foundation

@MainActor
protocol ChatService {
    func conversations(for userID: String) -> AsyncStream<[Conversation]>
    func messages(in conversationID: String) -> AsyncStream<[Message]>
    func send(text: String, to conversationID: String, from senderID: String) async throws
    func createConversation(participants: [User]) async throws -> String
    func markAsRead(conversationID: String, messageIDs: [String]) async
}
