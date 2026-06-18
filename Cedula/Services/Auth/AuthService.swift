//
//  AuthService.swift
//  Cedula
//
//  Created by Marko on 17.06.2026.
//

import Foundation

@MainActor
protocol AuthService {
    var currentUser: User? { get }
    func authState() -> AsyncStream<User?>
    func signIn(email: String, password: String) async throws
    func signUp(displayName: String, email: String, password: String) async throws
    func signOut() throws
}
