//
//  Conversation.swift
//  Cedula
//
//  Created by Marko on 17.06.2026.
//

import Foundation

struct Conversation: Identifiable, Hashable, Codable, Sendable {
    let id: String
    var title: String
    var participantIDs: [String]
    var lastMessageText: String
    var lastMessageDate: Date
    var unreadCount: Int
}
