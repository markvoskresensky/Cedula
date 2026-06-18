//
//  Chat.swift
//  Cedula
//
//  Created by Marko on 17.06.2026.
//

import SwiftUI

enum Chat {}

extension Chat {
    static func view(conversationID: String, title: String, currentUserID: String, chatService: ChatService, storageService: StorageService) -> some View {
        let model = ViewModel(
            conversationID: conversationID,
            title: title,
            currentUserID: currentUserID,
            chatService: chatService,
            storageService: storageService
        )
        return Chat.Screen(model: model)
    }
}
