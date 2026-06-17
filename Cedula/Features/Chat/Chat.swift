//
//  Chat.swift
//  Cedula
//
//  Created by Marko on 17.06.2026.
//

import SwiftUI

enum Chat {}

extension Chat {
    static func view(conversationID: String, title: String) -> some View {
        let model = ViewModel(
            conversationID: conversationID,
            title: title,
            currentUserID: SampleData.currentUser.id,
            chatService: MockChatService()
        )
        return Chat.Screen(model: model)
    }
}
