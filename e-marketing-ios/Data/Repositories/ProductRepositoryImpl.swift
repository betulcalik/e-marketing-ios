//
//  ProductRepositoyrImpl.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 20.09.2026.
//

import Foundation

final class ProductRepositoryImpl: ProductRepositoryProtocol {
    
    private let client: HTTPClientProtocol
    
    init(client: HTTPClientProtocol) {
        self.client = client
    }
    
    func categories() async throws -> [String] {
        let endpoint = Endpoint(path: "products/category-list")
        return try await client.send(endpoint, as: [String].self)
    }
}
