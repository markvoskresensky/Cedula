//
//  NewChat.swift
//  Cedula
//
//  Created by Marko on 18.06.2026.
//

import SwiftUI

enum NewChat {}

extension NewChat {
    static func view(currentUser: User, chatService: ChatService, userService: UserService) -> some View {
        let model = ViewModel(currentUser: currentUser, chatService: chatService, userService: userService)
        return NewChat.Screen(model: model)
    }
}
