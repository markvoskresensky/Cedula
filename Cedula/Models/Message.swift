//
//  Message.swift
//  Cedula
//
//  Created by Marko on 17.06.2026.
//

import Foundation

struct Message: Identifiable, Hashable, Codable, Sendable {
    let id: String
    let conversationID: String
    let senderID: String
    var text: String
    var imageURL: String?
    var sentAt: Date
    var status: Status

    enum Status: String, Codable, Sendable {
        case sending
        case sent
        case delivered
        case read
    }
}
