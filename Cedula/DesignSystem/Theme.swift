//
//  Theme.swift
//  Cedula
//
//  Created by Marko on 17.06.2026.
//

import SwiftUI

enum Theme {}

extension Theme {
    enum Spacing {
        static let xs: CGFloat = 4
        static let s: CGFloat = 8
        static let m: CGFloat = 12
        static let l: CGFloat = 16
        static let xl: CGFloat = 24
    }

    enum Radius {
        static let bubble: CGFloat = 18
    }

    enum Palette {
        static let accent = Color.accentColor
        static let bubbleOutgoing = Color.accentColor
        static let bubbleOutgoingText = Color.white
        static let bubbleIncoming = Color(.secondarySystemBackground)
        static let bubbleIncomingText = Color.primary
        static let screenBackground = Color(.systemBackground)
        static let secondaryText = Color.secondary
    }
}

extension Font {
    static let messageBody = Font.body
    static let conversationTitle = Font.headline
    static let conversationPreview = Font.subheadline
    static let timestamp = Font.caption2
}
