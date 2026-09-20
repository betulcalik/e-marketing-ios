//
//  ProductDTO.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 20.09.2026.
//

import Foundation

struct ProductListResponseDTO: Decodable {
    let products: [ProductDTO]
    let total: Int
    let skip: Int
    let limit: Int
}

struct ProductDTO: Decodable {
    let id: Int
    let title: String
    let thumbnail: String?
    let price: Double
    let discountPercentage: Double
    let rating: Double
    let category: String
}
