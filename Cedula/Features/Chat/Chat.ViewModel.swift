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
                await markIncomingAsRead()
            }
        }

        private func markIncomingAsRead() async {
            let unreadIDs = messages
                .filter { $0.senderID != currentUserID && $0.status != .read && $0.status != .sending }
                .map(\.id)
            guard !unreadIDs.isEmpty else { return }
            await chatService.markAsRead(conversationID: conversationID, messageIDs: unreadIDs)
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

        struct DayGroup: Identifiable {
            let id: Date
            let messages: [Message]
        }

        var dayGroups: [DayGroup] {
            let calendar = Calendar.current
            let grouped = Dictionary(grouping: messages) { calendar.startOfDay(for: $0.sentAt) }
            return grouped.keys.sorted().map { day in
                DayGroup(id: day, messages: grouped[day]?.sorted { $0.sentAt < $1.sentAt } ?? [])
            }
        }
    }
}

private extension Chat.ViewModel {
}
