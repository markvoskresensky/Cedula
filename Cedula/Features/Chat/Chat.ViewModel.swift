//
//  Chat.ViewModel.swift
//  Cedula
//
//  Created by Marko on 17.06.2026.
//

import Foundation

extension Chat {
    @MainActor
    @Observable
    final class ViewModel {
        let title: String
        private(set) var messages: [Message] = []
        var draft: String = ""

        let currentUserID: String
        private let conversationID: String
        private let chatService: ChatService

        init(conversationID: String, title: String, currentUserID: String, chatService: ChatService) {
            self.conversationID = conversationID
            self.title = title
            self.currentUserID = currentUserID
            self.chatService = chatService
        }

        func observe() async {
            for await messages in chatService.messages(in: conversationID) {
                self.messages = messages
            }
        }

        func send() async {
            let text = draft.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !text.isEmpty else { return }
            draft = ""
            try? await chatService.send(text: text, to: conversationID, from: currentUserID)
        }

        func isOutgoing(_ message: Message) -> Bool {
            message.senderID == currentUserID
        }
    }
}

private extension Chat.ViewModel {
}
