//
//  UserService.swift
//  Cedula
//
//  Created by Marko on 18.06.2026.
//

import Foundation

@MainActor
protocol UserService {
    func upsert(_ user: User) async throws
    func others(excluding userID: String) async throws -> [User]
    func addFCMToken(_ token: String, for userID: String) async
}
