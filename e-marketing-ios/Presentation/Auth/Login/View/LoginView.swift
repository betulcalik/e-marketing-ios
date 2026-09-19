//
//  LoginView.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 19.09.2026.
//

import SwiftUI

struct LoginView: View {
    
    @State private var viewModel: LoginViewModel
    @FocusState private var focusedField: Field?
    
    private enum Field {
        case username, password
    }
    
    init(viewModel: LoginViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 24) {
            form
            Spacer()
        }
        .navigationTitle("auth.login.title")
        .navigationBarTitleDisplayMode(.large)
        .padding(.top, 16)
        .padding(.horizontal, 20)
        .simultaneousGesture(TapGesture().onEnded { focusedField = nil })
        .errorAlert(message: viewModel.errorMessage, onDismiss: viewModel.clearError)
    }
}

// MARK: - Extensions
/// UI Components
extension LoginView {
    private var form: some View {
        VStack(alignment: .leading, spacing: 24) {
            AppTextField(
                title: "auth.field.username",
                text: $viewModel.username,
                hint: "auth.field.username.hint",
                contentType: .username,
                submitLabel: .next,
                identifier: "login.usernameField",
                field: .username,
                focus: $focusedField,
                onSubmit: { focusedField = .password }
            )
            
            AppTextField(
                title: "auth.field.password",
                text: $viewModel.password,
                hint: "******",
                isSecure: true,
                contentType: .password,
                submitLabel: .go,
                identifier: "login.passwordField",
                field: .password,
                focus: $focusedField,
                onSubmit: { }
            )
            
            submitButton
        }
    }
    
    private var submitButton: some View {
        AppButton(
            title: "auth.login.cta",
            isLoading: viewModel.isSubmitting,
            identifier: "login.submitButton"
        ) {
            submit()
        }
        .disabled(!viewModel.canSubmit)
    }
}

/// Actions
extension LoginView {
    private func submit() {
        focusedField = nil
        
        Task {
            await viewModel.submit()
        }
    }
}

// MARK: - Previews
#Preview {
    LoginView(viewModel: .preview)
}
