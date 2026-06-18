//
//  MockUserService.swift
//  Cedula
//
//  Created by Marko on 18.06.2026.
//

import Foundation

@MainActor
final class MockUserService: UserService {
    private var users: [User]

    init(users: [User]? = nil) {
        self.users = users ?? [SampleData.alice, SampleData.bob, SampleData.carol]
    }

    func upsert(_ user: User) async throws {
        if let index = users.firstIndex(where: { $0.id == user.id }) {
            users[index] = user
        } else {
            users.append(user)
        }
    }

    func others(excluding userID: String) async throws -> [User] {
        users.filter { $0.id != userID }
    }
}
