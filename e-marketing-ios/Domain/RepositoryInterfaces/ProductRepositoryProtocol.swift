//
//  ProductRepositoryProtocol.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 20.09.2026.
//

import Foundation

protocol ProductRepositoryProtocol {
    func categories() async throws -> [String]
    func products(limit: Int, skip: Int) async throws -> Page<Product>
    func products(category: String, limit: Int, skip: Int) async throws -> Page<Product>
}
