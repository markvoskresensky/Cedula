//
//  User.swift
//  Cedula
//
//  Created by Marko on 17.06.2026.
//

import Foundation

struct User: Identifiable, Hashable, Codable, Sendable {
    let id: String
    var displayName: String
    var avatarName: String?
}
