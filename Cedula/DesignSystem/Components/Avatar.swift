//
//  Avatar.swift
//  Cedula
//
//  Created by Marko on 17.06.2026.
//

import SwiftUI

struct Avatar: View {
    let name: String
    var size: CGFloat = 44

    var body: some View {
        Circle()
            .fill(Theme.Palette.bubbleIncoming)
            .frame(width: size, height: size)
            .overlay(
                Text(initials)
                    .font(.headline)
                    .foregroundStyle(Theme.Palette.secondaryText)
            )
    }

    private var initials: String {
        let parts = name.split(separator: " ").prefix(2)
        let letters = parts.compactMap(\.first).map(String.init)
        return letters.joined().uppercased()
    }
}
