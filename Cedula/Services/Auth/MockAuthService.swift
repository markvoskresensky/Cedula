//
//  MockAuthService.swift
//  Cedula
//
//  Created by Marko on 17.06.2026.
//

import Foundation

final class MockAuthService: AuthService {
    let currentUser: User

    init(currentUser: User = SampleData.currentUser) {
        self.currentUser = currentUser
    }
}
