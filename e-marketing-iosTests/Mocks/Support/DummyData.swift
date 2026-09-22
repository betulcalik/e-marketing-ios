//
//  DummyData.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 23.09.2026.
//

import Foundation
@testable import e_marketing_ios

extension Product {
    static var dummy: Product {
        Product(id: 1, title: "iPhone 16", thumbnail: nil, price: 42999,
                discountPercentage: 10, rating: 4.8, category: "smartphones")
    }

    static func dummies(count: Int, startingAt id: Int) -> [Product] {
        (id..<(id + count)).map {
            Product(id: $0, title: "Product \($0)", thumbnail: nil, price: 99,
                    discountPercentage: 10, rating: 4.5, category: "smartphones")
        }
    }
}

extension Page where T == Product {

    static func dummy(count: Int, total: Int, skip: Int) -> Page<Product> {
        Page(items: Product.dummies(count: count, startingAt: skip),
             total: total, skip: skip, limit: count)
    }
}
