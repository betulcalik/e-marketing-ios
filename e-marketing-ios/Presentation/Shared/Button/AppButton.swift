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
        HStack(spacing: 8) {
            if let icon {
                icon
                    .font(.subheadline)
                    .foregroundStyle(style == .outline ? Color.accentColor : Color.white)
            }
            
            if isLoading {
                ProgressView()
                    .tint(style == .primary ? Color.white : Color.accentColor)
            } else {
                Text(title)
                    .font(.body.weight(.semibold))
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(backgroundColor)
        .foregroundStyle(foregroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay {
            if style == .outline {
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(Color(.systemGray4), lineWidth: 1)
            }
        }
        .opacity(isEnabled ? 1 : 0.5)
    }
    
    private var backgroundColor: Color {
        switch (style, isEnabled) {
        case (.primary, true):  Color.accentColor
        case (.primary, false): Color(.systemGray5)
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
}

// MARK: - Previews
#if DEBUG
private struct AppButtonPreview: View {
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 20) {
            AppButton(title: "auth.login.cta", identifier: "preview.primary") {
                isLoading = true
                Task {
                    try? await Task.sleep(for: .seconds(2))
                    isLoading = false
                }
            }
            
            AppButton(title: "auth.login.cta", isLoading: true, identifier: "preview.loading") { }
            
            AppButton(title: "profile.logout", style: .outline,
                      icon: Image(systemName: "rectangle.portrait.and.arrow.right"),
                      identifier: "preview.outline") { }
        }
        .padding(24)
        .background(Color(.screenBackground))
    }
}

#Preview("AppButton") {
    AppButtonPreview()
}
#endif
