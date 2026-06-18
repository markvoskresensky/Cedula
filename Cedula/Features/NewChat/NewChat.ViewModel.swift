//
//  NewChat.ViewModel.swift
//  Cedula
//
//  Created by Marko on 18.06.2026.
//

import Foundation

extension NewChat {
    @MainActor
    @Observable
    final class ViewModel {
        enum State {
            case loading
            case loaded([User])
            case failed(String)
        }

        private(set) var state: State = .loading
        private(set) var isCreating = false

        private let currentUser: User
        private let chatService: ChatService
        private let userService: UserService

        init(currentUser: User, chatService: ChatService, userService: UserService) {
            self.currentUser = currentUser
            self.chatService = chatService
            self.userService = userService
        }

        func load() async {
            state = .loading
            do {
                let users = try await userService.others(excluding: currentUser.id)
                state = .loaded(users)
            } catch {
                state = .failed(error.localizedDescription)
            }
        }

        func startChat(with user: User) async {
            guard !isCreating else { return }
            isCreating = true
            _ = try? await chatService.createConversation(participants: [currentUser, user])
            isCreating = false
        }
    }
}

private extension NewChat.ViewModel {
}
