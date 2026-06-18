//
//  Root.ViewModel.swift
//  Cedula
//
//  Created by Marko on 17.06.2026.
//

import Foundation

extension Root {
    @MainActor
    @Observable
    final class ViewModel {
        enum State {
            case loading
            case signedOut
            case signedIn(User)
        }

        private(set) var state: State = .loading

        let authService: AuthService
        let userService: UserService
        let chatService: ChatService
        let networkMonitor: NetworkMonitor

        init(authService: AuthService, userService: UserService, chatService: ChatService, networkMonitor: NetworkMonitor) {
            self.authService = authService
            self.userService = userService
            self.chatService = chatService
            self.networkMonitor = networkMonitor
        }

        func observe() async {
            for await user in authService.authState() {
                if let user {
                    state = .signedIn(user)
                    try? await userService.upsert(user)
                } else {
                    state = .signedOut
                }
            }
        }
    }
}

private extension Root.ViewModel {
}
