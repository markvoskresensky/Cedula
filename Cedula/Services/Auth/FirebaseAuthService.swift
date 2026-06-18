//
//  FirebaseAuthService.swift
//  Cedula
//
//  Created by Marko on 17.06.2026.
//

import FirebaseAuth
import Foundation

@MainActor
final class FirebaseAuthService: AuthService {
    var currentUser: User? {
        Auth.auth().currentUser.map(Self.makeUser)
    }

    func authState() -> AsyncStream<User?> {
        AsyncStream { continuation in
            nonisolated(unsafe) let handle = Auth.auth().addStateDidChangeListener { _, firebaseUser in
                continuation.yield(firebaseUser.map(FirebaseAuthService.makeUser))
            }
            continuation.onTermination = { _ in
                Task { @MainActor in
                    Auth.auth().removeStateDidChangeListener(handle)
                }
            }
        }
    }

    func signIn(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }

    func signUp(displayName: String, email: String, password: String) async throws {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        let request = result.user.createProfileChangeRequest()
        request.displayName = displayName
        try await request.commitChanges()
        try await result.user.reload()
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }

    private static func makeUser(_ firebaseUser: FirebaseAuth.User) -> User {
        User(
            id: firebaseUser.uid,
            displayName: firebaseUser.displayName ?? firebaseUser.email ?? "User",
            email: firebaseUser.email,
            avatarName: nil
        )
    }
}
