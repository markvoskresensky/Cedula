//
//  MockAuthService.swift
//  Cedula
//
//  Created by Marko on 17.06.2026.
//

import Foundation

@MainActor
final class MockAuthService: AuthService {
    private(set) var currentUser: User?
    private var continuations: [AsyncStream<User?>.Continuation] = []

    init(currentUser: User? = nil) {
        self.currentUser = currentUser
    }

    func authState() -> AsyncStream<User?> {
        AsyncStream { continuation in
            continuation.yield(currentUser)
            continuations.append(continuation)
        }
    }

    func signIn(email: String, password: String) async throws {
        currentUser = User(id: "mock-uid", displayName: email, avatarName: nil)
        broadcast()
    }

    func signUp(displayName: String, email: String, password: String) async throws {
        currentUser = User(id: "mock-uid", displayName: displayName, avatarName: nil)
        broadcast()
    }

    func signOut() throws {
        currentUser = nil
        broadcast()
    }

    private func broadcast() {
        for continuation in continuations {
            continuation.yield(currentUser)
        }
    }
}
