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
            @Bindable var model = model
            return messages
                .navigationTitle(model.title)
                .navigationBarTitleDisplayMode(.inline)
                .safeAreaInset(edge: .bottom) {
                    ChatInputBar(text: $model.draft) {
                        Task { await model.send() }
                    }
                    .background(.bar)
                }
                .task { await model.observe() }
        }
    }
}

private extension Chat.Screen {
    var messages: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: Theme.Spacing.s) {
                    ForEach(model.messages) { message in
                        MessageBubble(message: message, isOutgoing: model.isOutgoing(message))
                            .id(message.id)
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

    func scrollToLast(_ proxy: ScrollViewProxy, animated: Bool) {
        guard let last = model.messages.last else { return }
        if animated {
            withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
        } else {
            proxy.scrollTo(last.id, anchor: .bottom)
        }
    }
}
