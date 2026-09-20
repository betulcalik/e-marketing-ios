//
//  ProfileView.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 20.09.2026.
//

import SwiftUI

struct ProfileView: View {

    @Environment(AppSessionStore.self) private var appSession
    @Environment(AppRouter.self) private var router

    var body: some View {
        content
            .background(Color(.screenBackground))
    }
}

// MARK: - Extensions
extension ProfileView {

    private var content: some View {
        VStack(spacing: 24) {
            Spacer(minLength: 32)
            avatar
            userInfo
            languageSection
            Spacer()
            logoutButton
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
    }

    private var avatar: some View {
        AsyncImage(url: appSession.session?.user?.image) { image in
            image.resizable().scaledToFill()
        } placeholder: {
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.tertiary)
        }
        .frame(width: 96, height: 96)
        .clipShape(Circle())
    }
    
    private var displayName: Text {
        guard let user = appSession.session?.user else {
            return Text("profile.guest")
        }
        
        let name = [user.firstName, user.lastName]
            .compactMap { $0 }
            .joined(separator: " ")
        
        return name.isEmpty ? Text("profile.guest") : Text(verbatim: name)
    }

    private var userInfo: some View {
        VStack(spacing: 6) {
            displayName
                .font(.title3.bold())

            Text(appSession.session?.user?.email ?? "")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    private var languageSection: some View {
        HStack {
            Text("profile.language")
                .font(.headline)
            
            Spacer()
            
            LanguagePicker()
        }
    }

    private var logoutButton: some View {
        AppButton(
            title: "profile.logout",
            style: .outline,
            icon: Image(systemName: "rectangle.portrait.and.arrow.right"),
            identifier: "profile.logout"
        ) {
            appSession.logout()
            router.reset()
        }
    }
}

// MARK: - Previews
#Preview("Profile") {
    ProfileView()
        .environment(AppSessionStore(keychainTokenStore: KeychainTokenStore()))
        .environment(AppRouter())
        .environment(LanguageStore(storage: UserDefaultsStore()))
}
