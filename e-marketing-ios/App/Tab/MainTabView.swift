//
//  MainTabView.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 20.09.2026.
//

import SwiftUI

/// Root shell for the authenticated world: Home and Profile tabs.
struct MainTabView: View {

    let homeViewModel: HomeViewModel

    @Environment(AppSessionStore.self) private var appSession
    @Environment(AppRouter.self) private var router

    var body: some View {
        @Bindable var router = router

        TabView {
            NavigationStack(path: $router.path) {
                HomeView(viewModel: homeViewModel)
                    .appDestinations(appSession: appSession, router: router)
            }
            .tabItem {
                Label("tab.home", systemImage: "house")
            }

            ProfileView()
                .tabItem {
                    Label("tab.profile", systemImage: "person")
                }
        }
    }
}

// MARK: - Previews
#if DEBUG
#Preview("MainTab") {
    MainTabView(homeViewModel: .preview)
        .environment(AppSessionStore(keychainTokenStore: KeychainTokenStore()))
        .environment(AppRouter())
}
#endif
