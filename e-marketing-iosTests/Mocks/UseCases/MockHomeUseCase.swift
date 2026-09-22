//
//  MockHomeUseCase.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 23.09.2026.
//

import Foundation
@testable import e_marketing_ios

@MainActor
final class MockHomeUseCase: HomeUseCaseProtocol {

    var stubbedCategories: [String] = []
    var stubbedFeatured: [Product] = []
    var stubbedError: Error?

    private(set) var callCount = 0

    func getCategories() async throws -> [String] {
        callCount += 1
        if let stubbedError { throw stubbedError }
        return stubbedCategories
    }

    func getFeaturedProducts() async throws -> [Product] {
        callCount += 1
        if let stubbedError { throw stubbedError }
        return stubbedFeatured
    }
}
