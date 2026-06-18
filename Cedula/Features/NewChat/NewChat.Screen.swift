//
//  NewChat.Screen.swift
//  Cedula
//
//  Created by Marko on 18.06.2026.
//

import SwiftUI

extension NewChat {
    struct Screen: View {
        @State private var model: ViewModel
        @Environment(\.dismiss) private var dismiss

        init(model: ViewModel) {
            _model = State(initialValue: model)
        }

        var body: some View {
            NavigationStack {
                content
                    .navigationTitle("new_chat_screen_title")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("common_cancel_button_title") { dismiss() }
                        }
                    }
                    .task { await model.load() }
            }
        }
    }
}

private extension NewChat.Screen {
    @ViewBuilder
    var content: some View {
        switch model.state {
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .failed(let message):
            ContentUnavailableView {
                Label("common_error_title", systemImage: "exclamationmark.triangle")
            } description: {
                Text(message)
            } actions: {
                Button("common_retry_button_title") { Task { await model.load() } }
            }
        case .loaded(let users):
            list(users)
        }
    }

    @ViewBuilder
    func list(_ users: [User]) -> some View {
        if users.isEmpty {
            ContentUnavailableView("new_chat_screen_empty_title", systemImage: "person.2")
        } else {
            List(users) { user in
                Button {
                    Task {
                        await model.startChat(with: user)
                        dismiss()
                    }
                } label: {
                    HStack(spacing: Theme.Spacing.m) {
                        Avatar(name: user.displayName)
                        Text(user.displayName)
                            .font(.conversationTitle)
                            .foregroundStyle(Theme.Palette.bubbleIncomingText)
                    }
                }
            }
            .listStyle(.plain)
            .disabled(model.isCreating)
        }
    }
}
