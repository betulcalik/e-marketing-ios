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

    init() {
        let sessionStore = AppSessionStore(keychainTokenStore: KeychainTokenStore())
        sessionStore.restore()
        _appSession = State(initialValue: sessionStore)
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                rootContent
                    .appDestinations(appSession: appSession, router: router)
            }
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
            HomeView(viewModel: HomeViewModel(
                homeUseCase: HomeUseCase(productRepository: ProductRepositoryImpl(client: HTTPClient()))
            ))
        } else {
            WelcomeView()
        }
    }
}
