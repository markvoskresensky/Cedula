//
//  ChatInputBar.swift
//  Cedula
//
//  Created by Marko on 17.06.2026.
//

import PhotosUI
import SwiftUI

struct ChatInputBar: View {
    @Binding var text: String
    let onSend: () -> Void
    var onPickImage: ((Data) -> Void)?

    @State private var pickerItem: PhotosPickerItem?

    var body: some View {
        HStack(spacing: Theme.Spacing.s) {
            if onPickImage != nil {
                PhotosPicker(selection: $pickerItem, matching: .images) {
                    Image(systemName: "photo")
                        .font(.title3)
                        .foregroundStyle(Theme.Palette.accent)
                }
            }

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
        .onChange(of: pickerItem) {
            guard let pickerItem else { return }
            Task {
                if let data = try? await pickerItem.loadTransferable(type: Data.self) {
                    onPickImage?(data)
                }
                self.pickerItem = nil
            }
        }
    }

    private var canSend: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
