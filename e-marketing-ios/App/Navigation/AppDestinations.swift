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
    let client: HTTPClientProtocol
    
    var body: some View {
        switch route {
        case .categories:
            CategoriesView(viewModel: CategoriesViewModel(
                homeUseCase: HomeUseCase(
                    productRepository: ProductRepositoryImpl(
                        client: client))))
        case .products(let category):
            ProductsView(viewModel: ProductsViewModel(
                category: category,
                productsUseCase: ProductsUseCase(
                    productRepository: ProductRepositoryImpl(
                        client: client)),
                onSessionExpired: {
                    appSession.expireSession()
                    router.reset()
                }
            ))
        }
    }
}
