//
//  Login.ViewModel.swift
//  Cedula
//
//  Created by Marko on 17.06.2026.
//

import Foundation

extension Login {
    @MainActor
    @Observable
    final class ViewModel {
        enum Mode {
            case signIn
            case signUp
        }

        var mode: Mode = .signIn
        var email = ""
        var password = ""
        var displayName = ""
        private(set) var isSubmitting = false
        private(set) var errorMessage: String?

        private let authService: AuthService

        init(authService: AuthService) {
            self.authService = authService
        }

        var canSubmit: Bool {
            guard !email.trimmingCharacters(in: .whitespaces).isEmpty, password.count >= 6 else {
                return false
            }
            if mode == .signUp {
                return !displayName.trimmingCharacters(in: .whitespaces).isEmpty
            }
            return true
        }

        var submitTitle: String {
            mode == .signIn ? "Sign In" : "Create Account"
        }

        var switchModeTitle: String {
            mode == .signIn ? "No account? Sign Up" : "Have an account? Sign In"
        }

        func toggleMode() {
            mode = (mode == .signIn) ? .signUp : .signIn
            errorMessage = nil
        }

        func submit() async {
            guard canSubmit else { return }
            isSubmitting = true
            errorMessage = nil
            do {
                switch mode {
                case .signIn:
                    try await authService.signIn(email: email, password: password)
                case .signUp:
                    try await authService.signUp(displayName: displayName, email: email, password: password)
                }
            } catch {
                errorMessage = error.localizedDescription
            }
            isSubmitting = false
        }
    }
}

private extension Login.ViewModel {
}
