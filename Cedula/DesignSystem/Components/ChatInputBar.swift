//
//  ChatInputBar.swift
//  Cedula
//
//  Created by Marko on 17.06.2026.
//

import SwiftUI

struct ChatInputBar: View {
    @Binding var text: String
    let onSend: () -> Void

    var body: some View {
        HStack(spacing: Theme.Spacing.s) {
            TextField("chat_input_bar_placeholder", text: $text, axis: .vertical)
                .textFieldStyle(.plain)
                .padding(.horizontal, Theme.Spacing.m)
                .padding(.vertical, Theme.Spacing.s)
                .background(Theme.Palette.bubbleIncoming)
                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.bubble, style: .continuous))

            Button(action: onSend) {
                Image(systemName: "arrow.up.circle.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundStyle(canSend ? Theme.Palette.accent : Theme.Palette.secondaryText)
            }
            .disabled(!canSend)
        }
        .padding(.horizontal, Theme.Spacing.m)
        .padding(.vertical, Theme.Spacing.s)
    }

    private var canSend: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
