//
//  ProductsViewModel+Preview.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 20.09.2026.
//

import Foundation

#if DEBUG
extension ProductsViewModel {
    static var preview: ProductsViewModel {
        ProductsViewModel(category: "beauty",
                          productsUseCase: MockProductsUseCase(),
                          onSessionExpired: {})
    }
}
#endif
