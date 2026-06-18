//
//  ConversationList.swift
//  Cedula
//
//  Created by Marko on 17.06.2026.
//

import SwiftUI

enum ConversationList {}

extension ConversationList {
    static func view(authService: AuthService, userService: UserService, chatService: ChatService) -> some View {
        let model = ViewModel(
            chatService: chatService,
            userService: userService,
            authService: authService
        )
        return ConversationList.Screen(model: model)
    }
}
