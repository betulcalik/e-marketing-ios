//
//  e_marketing_iosApp.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 19.09.2026.
//

import SwiftUI

@main
struct e_marketing_iosApp: App {
    @State private var appSession: AppSessionStore
    @State private var router = AppRouter()
    @State private var homeViewModel: HomeViewModel
    
    init() {
        let keychain = KeychainTokenStore()
        let sessionStore = AppSessionStore(keychainTokenStore: keychain)
        sessionStore.restore()
        _appSession = State(initialValue: sessionStore)
        _homeViewModel = State(initialValue: HomeViewModel(
            homeUseCase: HomeUseCase(
                productRepository: ProductRepositoryImpl(
                    client: HTTPClient(keychainTokenStore: keychain)
                )
            )))
    }

    var body: some Scene {
        WindowGroup {
            rootContent
            .environment(appSession)
            .environment(router)
        }
    }
}

// MARK: - Extensions
extension e_marketing_iosApp {
    @ViewBuilder
    private var rootContent: some View {
        if appSession.isAuthenticated {
            NavigationStack(path: $router.path) {
                HomeView(viewModel: homeViewModel)
                    .appDestinations(appSession: appSession, router: router)
            }
        } else {
            NavigationStack(path: $router.path) {
                WelcomeView()
                    .appDestinations(appSession: appSession, router: router)
            }
        }
    }
}
