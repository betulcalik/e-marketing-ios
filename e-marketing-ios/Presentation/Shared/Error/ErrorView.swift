//
//  ErrorView.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 20.09.2026.
//

import SwiftUI

/// Error state view: icon, message and retry action.
struct ErrorView: View {

    let message: String
    var iconName: String = "wifi.exclamationmark"
    var identifier: String? = nil
    let retryAction: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: iconName)
                .font(.system(size: 40))
                .foregroundStyle(.secondary)

            Text(message)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            AppButton(title: "error.retry", identifier: identifier) {
                retryAction()
            }
            .padding(.horizontal, 48)
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Previews
#if DEBUG
#Preview("ErrorView") {
    ErrorView(
        message: "No internet connection. Check your network and try again.",
        identifier: "preview.retry"
    ) { }
    .padding(.vertical, 24)
}
#endif
