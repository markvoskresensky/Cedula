//
//  Login.Screen.swift
//  Cedula
//
//  Created by Marko on 17.06.2026.
//

import SwiftUI

extension Login {
    struct Screen: View {
        @State private var model: ViewModel

        init(model: ViewModel) {
            _model = State(initialValue: model)
        }

        var body: some View {
            NavigationStack {
                Form {
                    if model.mode == .signUp {
                        Section {
                            TextField("login_screen_name_field_title", text: $model.displayName)
                                .textContentType(.name)
                        }
                    }

                    Section {
                        TextField("login_screen_email_field_title", text: $model.email)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                        SecureField("login_screen_password_field_title", text: $model.password)
                            .textContentType(model.mode == .signUp ? .newPassword : .password)
                    } footer: {
                        if let error = model.errorMessage {
                            Text(error).foregroundStyle(.red)
                        }
                    }

                    Section {
                        Button {
                            Task { await model.submit() }
                        } label: {
                            HStack {
                                Spacer()
                                if model.isSubmitting {
                                    ProgressView()
                                } else {
                                    Text(model.submitTitle)
                                }
                                Spacer()
                            }
                        }
                        .disabled(!model.canSubmit || model.isSubmitting)
                    }

                    Section {
                        Button(model.switchModeTitle) {
                            model.toggleMode()
                        }
                    }
                }
                .navigationTitle(model.mode == .signIn ? Text("login_screen_sign_in_title") : Text("login_screen_sign_up_title"))
            }
        }
    }
}
