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
    
    func products(limit: Int, skip: Int) async throws -> Page<Product> {
        let endpoint = Endpoint(
            path: "auth/products",
            queryItems: [
                URLQueryItem(name: "limit", value: String(limit)),
                URLQueryItem(name: "skip", value: String(skip)),
                URLQueryItem(name: "select", value: "title,thumbnail,price,discountPercentage,rating,category")
            ]
        )
        return try await client.send(endpoint, as: ProductListResponseDTO.self).toDomain
    }
    
    func products(category: String, limit: Int, skip: Int) async throws -> Page<Product> {
        let endpoint = Endpoint(
            path: "auth/products/category/\(category)",
            queryItems: [
                URLQueryItem(name: "limit", value: String(limit)),
                URLQueryItem(name: "skip", value: String(skip)),
                URLQueryItem(name: "select", value: "title,thumbnail,price,discountPercentage,rating,category")
            ]
        )
        return try await client.send(endpoint, as: ProductListResponseDTO.self).toDomain
    }
}
