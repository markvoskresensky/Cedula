//
//  DateSeparator.swift
//  Cedula
//
//  Created by Marko on 18.06.2026.
//

import SwiftUI

struct DateSeparator: View {
    let date: Date

    var body: some View {
        Text(label)
            .font(.caption2)
            .foregroundStyle(Theme.Palette.secondaryText)
            .padding(.vertical, Theme.Spacing.xs)
            .frame(maxWidth: .infinity)
    }

    private var label: String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return String(localized: "common_today")
        }
        if calendar.isDateInYesterday(date) {
            return String(localized: "common_yesterday")
        }
        return date.formatted(date: .abbreviated, time: .omitted)
    }
}
