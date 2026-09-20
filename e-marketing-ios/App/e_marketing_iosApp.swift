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
    @State private var loginViewModel: LoginViewModel
    
    private let sessionUseCase = SessionUseCase(
        loginRepository: LoginRepositoryImpl(
            client: HTTPClient(keychainTokenStore: KeychainTokenStore())
        )
    )
    
    init() {
        let keychain = KeychainTokenStore()
        let sessionStore = AppSessionStore(keychainTokenStore: keychain)
        sessionStore.restore()
        let router = AppRouter()
        
        _appSession = State(initialValue: sessionStore)
        _router = State(initialValue: router)
        _homeViewModel = State(initialValue: HomeViewModel(
            homeUseCase: HomeUseCase(productRepository: ProductRepositoryImpl(
                client: HTTPClient(keychainTokenStore: keychain)))
        ))
        _loginViewModel = State(initialValue: LoginViewModel(
            loginUseCase: LoginUseCase(loginRepository: LoginRepositoryImpl(
                client: HTTPClient(keychainTokenStore: keychain))),
            onAuthenticated: { session in
                sessionStore.login(session: session)
                router.reset()
            }
        ))
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                rootContent
                    .appDestinations(appSession: appSession, router: router)
            }
            .environment(appSession)
            .environment(router)
            .task { await restoreUserIfNeeded() }
        }
    }
}

// MARK: - Extensions
extension e_marketing_iosApp {
    @ViewBuilder
    private var rootContent: some View {
        if appSession.isAuthenticated {
            HomeView(viewModel: homeViewModel)
        } else {
            LoginView(viewModel: loginViewModel)
        }
    }
    
    private func restoreUserIfNeeded() async {
        guard appSession.isAuthenticated, appSession.session?.user == nil else { return }
        
        do {
            let user = try await sessionUseCase.getCurrentUser()
            appSession.updateUser(user)
        } catch let error as AppError where error.isSessionExpired {
            appSession.logout()
            router.reset()
        } catch {
            // Display anonymous welcome
        }
    }
}
