//
//  AppDestinations.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 19.09.2026.
//

import SwiftUI

struct AppDestinationView: View {
    let route: AppRoute
    let appSession: AppSessionStore
    let router: AppRouter

    var body: some View {
        switch route {
        case .login:
            LoginView(
                viewModel: LoginViewModel(
                    loginUseCase: LoginUseCase(loginRepository: LoginRepositoryImpl(client: HTTPClient(keychainTokenStore: KeychainTokenStore()))),
                    onAuthenticated: { session in
                        appSession.login(session: session)
                        router.reset()
                    }
                ))
        case .products(let category):
            ProductsView(viewModel: ProductsViewModel(
                category: category,
                productsUseCase: ProductsUseCase(
                    productRepository: ProductRepositoryImpl(client: HTTPClient(keychainTokenStore: KeychainTokenStore()))
                ),
                onSessionExpired: {
                    appSession.logout()
                    router.reset()
                }
            ))
        }
    }
}
