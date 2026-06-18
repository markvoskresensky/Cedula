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

        init(authService: AuthService) {
            self.authService = authService
        }

        func observe() async {
            for await user in authService.authState() {
                state = user.map(State.signedIn) ?? .signedOut
            }
        }
    }
}

private extension Root.ViewModel {
}
