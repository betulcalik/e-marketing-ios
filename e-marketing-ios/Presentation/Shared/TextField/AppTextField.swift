//
//  AppTextField.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 19.09.2026.
//

import SwiftUI

struct AppTextField<Field: Hashable>: View {

    let title: LocalizedStringKey
    @Binding var text: String
    var hint: LocalizedStringKey? = nil

    var isSecure = false
    var contentType: UITextContentType? = nil
    var submitLabel: SubmitLabel = .next
    var identifier: String? = nil

    let field: Field
    let focus: FocusState<Field?>.Binding
    var onSubmit: (() -> Void)? = nil

    @State private var showsPassword = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            titleView

            HStack(spacing: 8) {
                fieldView
                
                if isSecure {
                    passwordToggleButton
                }
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(focus.wrappedValue == field ? Color.accentColor : Color.gray.opacity(0.5), lineWidth: 1.5)
            }
        }
        .animation(.easeInOut(duration: 0.15), value: focus.wrappedValue == field)
    }
}

// MARK: - Extensions
extension AppTextField {
    private var titleView: some View {
        Text(title)
            .font(.footnote.weight(.medium))
            .foregroundStyle(.secondary)
    }
    
    @ViewBuilder
    private var fieldView: some View {
        ZStack(alignment: .leading) {
            if let hint, text.isEmpty {
                Text(hint)
                    .font(.body)
                    .foregroundStyle(Color(.placeholderText))
                    .allowsHitTesting(false)
            }
            
            if isSecure && !showsPassword {
                SecureField(hint ?? "", text: $text)
                    .textContentType(contentType)
                    .accessibilityIdentifier(identifier ?? "")
                    .focused(focus, equals: field)
                    .submitLabel(submitLabel)
                    .onSubmit { onSubmit?() }
            } else {
                TextField(hint ?? "", text: $text)
                    .textContentType(contentType)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .accessibilityIdentifier(identifier ?? "")
                    .focused(focus, equals: field)
                    .submitLabel(submitLabel)
                    .onSubmit { onSubmit?() }
            }
        }
    }
    
    private var passwordToggleButton: some View {
        Button {
            showsPassword.toggle()
        } label: {
            Image(systemName: showsPassword ? "eye.slash" : "eye")
                .foregroundStyle(.secondary)
        }
        .accessibilityLabel(Text(showsPassword ? "auth.a11y.hidePassword" : "auth.a11y.showPassword"))
    }
}

// MARK: - Preview
private struct AppTextFieldPreview: View {

    private enum PreviewField { case username, password }

    @State private var username = ""
    @State private var password = "test123"
    @FocusState private var focused: PreviewField?

    var body: some View {
        VStack(spacing: 20) {
            AppTextField(
                title: "auth.field.username",
                text: $username,
                hint: "auth.field.username.hint",
                contentType: .username,
                identifier: "preview.usernameField",
                field: .username,
                focus: $focused,
                onSubmit: { focused = .password }
            )

            AppTextField(
                title: "auth.field.password",
                text: $password,
                isSecure: true,
                contentType: .password,
                submitLabel: .go,
                identifier: "preview.passwordField",
                field: .password,
                focus: $focused,
                onSubmit: { }
            )
        }
        .padding(24)
    }
}

#Preview {
    AppTextFieldPreview()
}

#Preview("Dark") {
    AppTextFieldPreview()
        .preferredColorScheme(.dark)
}
