//
//  MockProductsUseCase.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 23.09.2026.
//

import Foundation
@testable import e_marketing_ios

@MainActor
final class MockProductsUseCase: ProductsUseCaseProtocol {

    var stubbedPage: Page<Product> = .dummy(count: 0, total: 0, skip: 0)
    var stubbedError: Error?

    private(set) var callCount = 0

    func getProducts(category: String?, limit: Int, skip: Int) async throws -> Page<Product> {
        callCount += 1

        if let stubbedError { throw stubbedError }

        return stubbedPage
    }
}
