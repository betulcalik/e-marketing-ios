//
//  ProductUseCase.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 20.09.2026.
//

import Foundation

protocol ProductsUseCaseProtocol: AnyObject {
    func getProducts(category: String?, limit: Int, skip: Int) async throws -> Page<Product>
}

final class ProductsUseCase: ProductsUseCaseProtocol {
    
    private let productRepository: ProductRepositoryProtocol
    
    init(productRepository: ProductRepositoryProtocol) {
        self.productRepository = productRepository
    }
    
    func getProducts(category: String?, limit: Int, skip: Int) async throws -> Page<Product> {
        if let category {
            return try await productRepository.products(category: category, limit: limit, skip: skip)
        }
        return try await productRepository.products(limit: limit, skip: skip)
    }
}
