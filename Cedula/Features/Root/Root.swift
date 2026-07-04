//
//  Root.swift
//  Cedula
//
//  Created by Marko on 17.06.2026.
//

import SwiftUI

enum Root {}

extension Root {
    static func view() -> some View {
        let model = ViewModel(
            authService: FirebaseAuthService(),
            userService: FirestoreUserService(),
            chatService: FirestoreChatService(),
            storageService: FirebaseStorageService(),
            networkMonitor: NetworkMonitor()
        )
        return Root.Screen(model: model)
    }
}
