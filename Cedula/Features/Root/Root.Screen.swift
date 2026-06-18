//
//  Root.Screen.swift
//  Cedula
//
//  Created by Marko on 17.06.2026.
//

import SwiftUI

extension Root {
    struct Screen: View {
        @State private var model: ViewModel

        init(model: ViewModel) {
            _model = State(initialValue: model)
        }

        var body: some View {
            content
                .safeAreaInset(edge: .top, spacing: 0) {
                    if !model.networkMonitor.isConnected {
                        NoConnectionBanner()
                            .transition(.move(edge: .top))
                    }
                }
                .animation(.default, value: model.networkMonitor.isConnected)
                .task { await model.observe() }
        }
    }
}

private extension Root.Screen {
    @ViewBuilder
    var content: some View {
        switch model.state {
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .signedOut:
            Login.view(authService: model.authService, userService: model.userService)
        case .signedIn:
            ConversationList.view(
                authService: model.authService,
                userService: model.userService,
                chatService: model.chatService
            )
        }
    }
}
