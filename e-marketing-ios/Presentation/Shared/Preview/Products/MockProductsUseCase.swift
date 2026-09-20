//
//  MockProductsUseCase.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 20.09.2026.
//

import Foundation

#if DEBUG
final class MockProductsUseCase: ProductsUseCaseProtocol {
    func getProducts(category: String?, limit: Int, skip: Int) async throws -> Page<Product> {
        try await Task.sleep(for: .seconds(1))
        return Page(
            items: (skip..<skip+limit).map { i in
                Product(id: i,
                        title: "Product #\(i)",
                        thumbnail: nil,
                        price: Double(i) * 12.5 + 9.99,
                        discountPercentage: 10,
                        rating: 4.5,
                        category: category ?? "all")
            },
            total: 35, skip: skip, limit: limit
        )
    }
}
#endif
