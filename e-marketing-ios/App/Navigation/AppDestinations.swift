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
        case .categories:
            CategoriesView(viewModel: CategoriesViewModel(
                homeUseCase: HomeUseCase(productRepository: ProductRepositoryImpl(client: HTTPClient(keychainTokenStore: KeychainTokenStore())))
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
