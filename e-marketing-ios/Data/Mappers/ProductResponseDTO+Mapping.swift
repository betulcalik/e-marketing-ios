//
//  ProductResponseDTO+Mapping.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 20.09.2026.
//

import Foundation

extension ProductDTO {
    var toDomain: Product {
        Product(id: id,
                title: title,
                thumbnail: thumbnail.flatMap(URL.init(string:)),
                price: price,
                discountPercentage: discountPercentage,
                rating: rating,
                category: category)
    }
}

extension ProductListResponseDTO {
    var toDomain: Page<Product> {
        Page(items: products.map(\.toDomain),
             total: total,
             skip: skip,
             limit: limit)
    }
}
