//
//  NoConnectionBanner.swift
//  Cedula
//
//  Created by Marko on 18.06.2026.
//

import SwiftUI

struct NoConnectionBanner: View {
    var body: some View {
        Label("common_no_connection_banner", systemImage: "wifi.slash")
            .font(.footnote.weight(.medium))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, Theme.Spacing.s)
            .background(.red)
    }
}
