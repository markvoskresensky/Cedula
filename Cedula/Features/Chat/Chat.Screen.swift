//
//  Chat.Screen.swift
//  Cedula
//
//  Created by Marko on 17.06.2026.
//

import SwiftUI

extension Chat {
    struct Screen: View {
        @State private var model: ViewModel

        init(model: ViewModel) {
            _model = State(initialValue: model)
        }

        var body: some View {
            messages
                .navigationTitle(model.title)
                .navigationBarTitleDisplayMode(.inline)
                .safeAreaInset(edge: .bottom) {
                    VStack(spacing: 0) {
                        if model.isOtherTyping {
                            Text("chat_typing_indicator")
                                .font(.caption)
                                .foregroundStyle(Theme.Palette.secondaryText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, Theme.Spacing.m)
                                .padding(.top, Theme.Spacing.xs)
                        }
                        ChatInputBar(text: $model.draft) {
                            Task { await model.send() }
                        } onPickImage: { data in
                            Task { await model.sendImage(data) }
                        }
                    }
                    .background(.bar)
                }
                .animation(.default, value: model.isOtherTyping)
                .task { await model.observe() }
                .task { await model.observeTyping() }
                .onDisappear { model.stopTyping() }
        }
    }
}

private extension Chat.Screen {
    var messages: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: Theme.Spacing.s) {
                    ForEach(model.dayGroups) { group in
                        DateSeparator(date: group.id)
                        ForEach(group.messages) { message in
                            row(for: message)
                                .id(message.id)
                        }
                    }
                }
                .padding(.horizontal, Theme.Spacing.m)
                .padding(.vertical, Theme.Spacing.s)
            }
            .onChange(of: model.messages.count) {
                scrollToLast(proxy, animated: true)
            }
            .onAppear {
                scrollToLast(proxy, animated: false)
            }
        }
    }

    @ViewBuilder
    func row(for message: Message) -> some View {
        let isOutgoing = model.isOutgoing(message)
        HStack(alignment: .bottom, spacing: Theme.Spacing.xs) {
            if !isOutgoing {
                Avatar(name: model.title, size: 28)
            }
            MessageBubble(message: message, isOutgoing: isOutgoing)
        }
    }

    func scrollToLast(_ proxy: ScrollViewProxy, animated: Bool) {
        guard let last = model.messages.last else { return }
        if animated {
            withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
        } else {
            proxy.scrollTo(last.id, anchor: .bottom)
        }
    }
}
