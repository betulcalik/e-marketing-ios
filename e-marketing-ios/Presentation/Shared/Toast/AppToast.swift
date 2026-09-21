//
//  AppToast.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 21.09.2026.
//

import SwiftUI

struct AppToast: View {

    let messageKey: String
    var systemImage: String = "info.circle"
    var tint: Color = .accentColor
    var duration: Duration = .seconds(4)
    let onDismiss: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: systemImage)
                .foregroundStyle(tint)

            Text(LocalizedStringKey(messageKey))
                .font(.footnote.weight(.medium))
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(.regularMaterial, in: Capsule())
        .overlay(Capsule().strokeBorder(tint.opacity(0.3)))
        .padding(.horizontal, 24)
        .onTapGesture { onDismiss() }
        .transition(.move(edge: .top).combined(with: .opacity))
        .task {
            try? await Task.sleep(for: duration)
            onDismiss()
        }
        .accessibilityIdentifier("toast")
    }
}

// MARK: - Previews
#Preview("Toast") {
    AppToast(messageKey: "error.unauthorized",
             systemImage: "clock.badge.exclamationmark",
             tint: .orange) { }
        .padding(.vertical, 32)
}
