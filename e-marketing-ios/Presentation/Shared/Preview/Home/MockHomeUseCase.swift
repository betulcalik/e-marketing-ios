//
//  MockHomeUseCase.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 20.09.2026.
//

import Foundation

#if DEBUG
final class MockHomeUseCase: HomeUseCaseProtocol {
    func getCategories() async throws -> [String] {
        try await Task.sleep(for: .seconds(1))
        return ["beauty", "fragrances", "furniture", "laptops", "mens-shirts", "smartphones"]
    }
    
    func getFeaturedProducts() async throws -> [Product] {
        try await Task.sleep(for: .seconds(1))
        return [
            Product(id: 1, title: "iPhone 16", thumbnail: nil, price: 42999,
                    discountPercentage: 10, rating: 4.8, category: "smartphones"),
            Product(id: 2, title: "Tennis Racket", thumbnail: nil, price: 899,
                    discountPercentage: 19.6, rating: 4.5, category: "sports-accessories")
        ]
    }
}
#endif
