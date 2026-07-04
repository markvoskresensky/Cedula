//
//  ConversationList.Screen.swift
//  Cedula
//
//  Created by Marko on 17.06.2026.
//

import SwiftUI

extension ConversationList {
    struct Screen: View {
        @State private var model: ViewModel

        init(model: ViewModel) {
            _model = State(initialValue: model)
        }

        var body: some View {
            NavigationStack {
                content
                    .navigationTitle("conversation_list_screen_title")
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("conversation_list_screen_sign_out_button_title", systemImage: "rectangle.portrait.and.arrow.right") {
                                model.signOut()
                            }
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("conversation_list_screen_new_chat_button_title", systemImage: "square.and.pencil") {
                                model.isPresentingNewChat = true
                            }
                        }
                    }
                    .task { await model.observe() }
                    .sheet(isPresented: $model.isPresentingNewChat) {
                        NewChat.view(
                            currentUser: model.currentUser,
                            chatService: model.chatService,
                            userService: model.userService
                        )
                    }
            }
        }
    }
}

private extension ConversationList.Screen {
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
                Button("common_retry_button_title") { Task { await model.observe() } }
            }
        case .loaded(let conversations):
            list(conversations)
        }
    }

    @ViewBuilder
    func list(_ conversations: [Conversation]) -> some View {
        if conversations.isEmpty {
            ContentUnavailableView("conversation_list_screen_empty_title", systemImage: "bubble.left.and.bubble.right")
        } else {
            List(conversations) { conversation in
                NavigationLink {
                    Chat.view(
                        conversationID: conversation.id,
                        title: conversation.title,
                        currentUserID: model.currentUser.id,
                        chatService: model.chatService,
                        storageService: model.storageService
                    )
                } label: {
                    ConversationList.Row(conversation: conversation)
                }
            }
            .listStyle(.plain)
        }
    }
}

extension ConversationList {
    struct Row: View {
        let conversation: Conversation

        var body: some View {
            HStack(spacing: Theme.Spacing.m) {
                Avatar(name: conversation.title)

                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    HStack {
                        Text(conversation.title)
                            .font(.conversationTitle)
                        Spacer()
                        Text(conversation.lastMessageDate, style: .time)
                            .font(.timestamp)
                            .foregroundStyle(Theme.Palette.secondaryText)
                    }

                    HStack {
                        Text(conversation.lastMessageText)
                            .font(.conversationPreview)
                            .foregroundStyle(Theme.Palette.secondaryText)
                            .lineLimit(1)
                        Spacer()
                        if conversation.unreadCount > 0 {
                            Text("\(conversation.unreadCount)")
                                .font(.caption2.bold())
                                .foregroundStyle(.white)
                                .padding(.horizontal, Theme.Spacing.s)
                                .padding(.vertical, 2)
                                .background(Theme.Palette.accent)
                                .clipShape(Capsule())
                        }
                    }
                }
            }
            .padding(.vertical, Theme.Spacing.xs)
        }
    }
}
