//
//  ConversationList.swift
//  Cedula
//
//  Created by Marko on 17.06.2026.
//

import SwiftUI

enum ConversationList {}

extension ConversationList {
    static func view(authService: AuthService) -> some View {
        let model = ViewModel(chatService: MockChatService(), authService: authService)
        return ConversationList.Screen(model: model)
    }
}
