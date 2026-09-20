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
}
#endif
