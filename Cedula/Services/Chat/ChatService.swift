//
//  ChatService.swift
//  Cedula
//
//  Created by Marko on 17.06.2026.
//

import Foundation

@MainActor
protocol ChatService {
    func loadConversations() async -> [Conversation]
    func messages(in conversationID: String) -> AsyncStream<[Message]>
    func send(text: String, to conversationID: String, from senderID: String) async throws
}
