//
//  WelcomeView.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 19.09.2026.
//

import SwiftUI

struct WelcomeView: View {
    @Environment(AppRouter.self) private var router

    var body: some View {
        VStack(spacing: 24) {
            headerView
            actionButtons
            Spacer()
        }
        .padding(.top, 40)
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

// MARK: - Extensions
extension WelcomeView {
    private var headerView: some View {
        Text("auth.welcome.title")
            .font(.system(size: 34, weight: .bold))
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            AppButton(
                title: "auth.welcome.signInWithEmail",
                style: .outline,
                icon: Image(systemName: "envelope"),
                identifier: "welcome.signInWithEmail"
            ) {
                router.push(.login)
            }
        }
    }
}

#Preview {
    WelcomeView()
        .environment(AppRouter())
}
