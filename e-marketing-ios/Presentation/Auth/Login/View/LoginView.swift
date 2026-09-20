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
        GeometryReader { proxy in
            ScrollView {
                content
                .frame(maxWidth: .infinity)
                .frame(minHeight: proxy.size.height)
            }
            .scrollDismissesKeyboard(.interactively)
            .scrollIndicators(.hidden)
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .background(BackgroundView())
        .simultaneousGesture(TapGesture().onEnded { focusedField = nil })
        .errorAlert(message: viewModel.errorMessage, onDismiss: viewModel.clearError)
    }
}

// MARK: - Extensions
extension LoginView {
    
    private var content: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 24)
            headerView
            cardView
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Image(.appLogo)
                .resizable()
                .scaledToFit()
                .frame(height: 120)
                .foregroundStyle(.white)
                .accessibilityHidden(true)

            VStack(spacing: 2) {
                Text("app.name")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.white)

                Text("auth.app.tagline")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.85))
            }
        }
        .padding(.bottom, 32)
    }
    
    private var cardView: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                Text("auth.login.welcome")
                    .font(.title2.bold())
                    .foregroundStyle(.primary)
                
                Text("auth.login.subtitle")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            AppTextField(
                title: "auth.field.username",
                text: $viewModel.username,
                hint: "auth.field.username.hint",
                contentType: .username,
                submitLabel: .next,
                identifier: "login.usernameField",
                leadingIcon: "person",
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
                leadingIcon: "lock",
                field: .password,
                focus: $focusedField,
                onSubmit: { submit() }
            )
            
            AppButton(title: "auth.login.cta",
                      isLoading: viewModel.isSubmitting,
                      identifier: "login.submitButton") {
                submit()
            }
            .disabled(!viewModel.canSubmit)
            .padding(.top, 8)
        }
        .padding(24)
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity, alignment: .top)
        .background(
            UnevenRoundedRectangle(topLeadingRadius: 28, topTrailingRadius: 28)
                .fill(Color(.systemBackground))
                .ignoresSafeArea(edges: .bottom)
        )
    }
    
    private func submit() {
        focusedField = nil
        Task { await viewModel.submit() }
    }
}

// MARK: - Previews
#Preview("Login") {
    LoginView(viewModel: .preview)
}
