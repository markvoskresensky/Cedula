//
//  ConversationList.ViewModel.swift
//  Cedula
//
//  Created by Marko on 17.06.2026.
//

import Foundation

extension ConversationList {
    @MainActor
    @Observable
    final class ViewModel {
        enum State {
            case loading
            case loaded([Conversation])
            case failed(String)
        }

        private(set) var state: State = .loading

        private let chatService: ChatService
        private let authService: AuthService

        init(chatService: ChatService, authService: AuthService) {
            self.chatService = chatService
            self.authService = authService
        }

        func load() async {
            state = .loading
            let conversations = await chatService.loadConversations()
            state = .loaded(conversations)
        }

        func signOut() {
            try? authService.signOut()
        }
    }
}

private extension ConversationList.ViewModel {
}
