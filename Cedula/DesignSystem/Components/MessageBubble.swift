//
//  MessageBubble.swift
//  Cedula
//
//  Created by Marko on 17.06.2026.
//

import SwiftUI

struct MessageBubble: View {
    let message: Message
    let isOutgoing: Bool

    var body: some View {
        HStack {
            if isOutgoing { Spacer(minLength: Theme.Spacing.xl) }

            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                Text(message.text)
                    .font(.messageBody)
                    .foregroundStyle(textColor)

                HStack(spacing: Theme.Spacing.xs) {
                    Text(message.sentAt, style: .time)
                        .font(.timestamp)
                        .foregroundStyle(timeColor)

                    if isOutgoing, let statusSymbol {
                        Image(systemName: statusSymbol)
                            .font(.timestamp)
                            .foregroundStyle(timeColor)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal, Theme.Spacing.m)
            .padding(.vertical, Theme.Spacing.s)
            .background(isOutgoing ? Theme.Palette.bubbleOutgoing : Theme.Palette.bubbleIncoming)
            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.bubble, style: .continuous))

            if !isOutgoing { Spacer(minLength: Theme.Spacing.xl) }
        }
    }

    private var textColor: Color {
        isOutgoing ? Theme.Palette.bubbleOutgoingText : Theme.Palette.bubbleIncomingText
    }

    private var timeColor: Color {
        isOutgoing ? Theme.Palette.bubbleOutgoingText.opacity(0.7) : Theme.Palette.secondaryText
    }

    private var statusSymbol: String? {
        switch message.status {
        case .sending: "clock"
        case .sent: "checkmark"
        case .delivered: "checkmark.circle"
        case .read: "checkmark.circle.fill"
        }
    }
}
