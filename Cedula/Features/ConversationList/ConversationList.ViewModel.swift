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
        var isPresentingNewChat = false

        let chatService: ChatService
        let userService: UserService
        private let authService: AuthService

        var currentUser: User {
            authService.currentUser ?? SampleData.currentUser
        }

        init(chatService: ChatService, userService: UserService, authService: AuthService) {
            self.chatService = chatService
            self.userService = userService
            self.authService = authService
        }

        func observe() async {
            for await conversations in chatService.conversations(for: currentUser.id) {
                state = .loaded(conversations)
            }
        }

        func signOut() {
            try? authService.signOut()
        }
    }
}

private extension ConversationList.ViewModel {
}
