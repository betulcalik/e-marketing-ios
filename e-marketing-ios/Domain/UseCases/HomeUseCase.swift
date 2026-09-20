//
//  HomeUseCase.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 20.09.2026.
//

protocol HomeUseCaseProtocol: AnyObject {
    func getCategories() async throws -> [String]
    func getFeaturedProducts() async throws -> [Product]
}

final class HomeUseCase: HomeUseCaseProtocol {
    private let productRepository: ProductRepositoryProtocol
    
    init(productRepository: ProductRepositoryProtocol) {
        self.productRepository = productRepository
    }
    
    func getCategories() async throws -> [String] {
        try await productRepository.categories()
    }
    
    func getFeaturedProducts() async throws -> [Product] {
        try await productRepository.featuredProducts(limit: 6)
    }
}
