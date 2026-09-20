//
//  HomeUseCase.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 20.09.2026.
//

protocol HomeUseCaseProtocol: AnyObject {
    func getCategories() async throws -> [String]
}

final class HomeUseCase: HomeUseCaseProtocol {
    private let productRepository: ProductRepositoryProtocol
    
    init(productRepository: ProductRepositoryProtocol) {
        self.productRepository = productRepository
    }
    
    func getCategories() async throws -> [String] {
        try await productRepository.categories()
    }
}
