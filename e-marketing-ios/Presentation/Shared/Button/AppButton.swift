//
//  AppButton.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 19.09.2026.
//

import SwiftUI

struct AppButton: View {
    
    enum Style {
        case primary
        case outline
    }

    let title: LocalizedStringKey
    var style: Style = .primary
    var icon: Image? = nil
    var isLoading = false
    var identifier: String? = nil
    let action: () -> Void

    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        Button {
            action()
        } label: {
            labelView
        }
        .buttonStyle(.plain)
        .disabled(isLoading)
        .animation(.easeInOut(duration: 0.15), value: isEnabled)
        .accessibilityIdentifier(identifier ?? "")
        .accessibilityLabel(Text(title))
    }
}

// MARK: - Extensions
extension AppButton {
    private var labelView: some View {
        HStack(spacing: 12) {
            if let icon {
                icon
            }

            if isLoading {
                ProgressView()
                    .tint(foregroundColor)
            } else {
                Text(title)
                    .font(font)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 52)
        .background(backgroundColor)
        .foregroundStyle(foregroundColor)
        .clipShape(Capsule())
        .overlay {
            if style == .outline {
                Capsule().strokeBorder(Color.primary, lineWidth: 1)
            }
        }
        .opacity(isEnabled ? 1 : (style == .outline ? 0.4 : 1))
    }

    private var backgroundColor: Color {
        switch (style, isEnabled) {
        case (.primary, true):  Color.accentColor
        case (.primary, false): Color(.systemGray4)
        case (.outline, _):     Color(.systemBackground)
        }
    }

    private var foregroundColor: Color {
        switch (style, isEnabled) {
        case (.primary, true):  Color.white
        case (.primary, false): Color(.secondaryLabel)
        case (.outline, _):     Color.primary
        }
    }

    private var font: Font {
        style == .primary ? .headline : .body.weight(.semibold)
    }
}

// MARK: - Preview
#Preview {
    AppButton(
        title: "auth.login.cta",
        identifier: "preview.primary"
    ) { }
    
    AppButton(
        title: "auth.login.cta",
        identifier: "preview.primary"
    ) { }
    .disabled(true)
    
    AppButton(
        title: "auth.login.cta",
        isLoading: true,
        identifier: "preview.loading"
    ) { }
}
