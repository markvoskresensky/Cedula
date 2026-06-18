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
            @Bindable var model = model
            return NavigationStack {
                Form {
                    if model.mode == .signUp {
                        Section {
                            TextField("Name", text: $model.displayName)
                                .textContentType(.name)
                        }
                    }

                    Section {
                        TextField("Email", text: $model.email)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                        SecureField("Password", text: $model.password)
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
                .navigationTitle(model.mode == .signIn ? "Sign In" : "Sign Up")
            }
        }
    }
}
