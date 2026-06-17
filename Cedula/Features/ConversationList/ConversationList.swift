//
//  ConversationList.swift
//  Cedula
//
//  Created by Marko on 17.06.2026.
//

import SwiftUI

enum ConversationList {}

extension ConversationList {
    static func view() -> some View {
        let model = ViewModel(chatService: MockChatService())
        return ConversationList.Screen(model: model)
    }
}
