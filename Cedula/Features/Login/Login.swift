//
//  Login.swift
//  Cedula
//
//  Created by Marko on 17.06.2026.
//

import SwiftUI

enum Login {}

extension Login {
    static func view(authService: AuthService) -> some View {
        let model = ViewModel(authService: authService)
        return Login.Screen(model: model)
    }
}
