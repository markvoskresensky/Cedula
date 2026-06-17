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
                    .navigationTitle("Chats")
                    .task { await model.load() }
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
                Label("Something went wrong", systemImage: "exclamationmark.triangle")
            } description: {
                Text(message)
            } actions: {
                Button("Retry") { Task { await model.load() } }
            }
        case .loaded(let conversations):
            list(conversations)
        }
    }

    @ViewBuilder
    func list(_ conversations: [Conversation]) -> some View {
        if conversations.isEmpty {
            ContentUnavailableView("No chats yet", systemImage: "bubble.left.and.bubble.right")
        } else {
            List(conversations) { conversation in
                NavigationLink {
                    Chat.view(conversationID: conversation.id, title: conversation.title)
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
