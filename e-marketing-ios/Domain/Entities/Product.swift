//
//  Product.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 20.09.2026.
//

import Foundation

struct Product: Equatable, Identifiable {
    let id: Int
    let title: String
    let thumbnail: URL?
    let price: Double
    let discountPercentage: Double
    let rating: Double
    let category: String
}

struct Page<T> {
    let items: [T]
    let total: Int
    let skip: Int
    let limit: Int

    var hasMore: Bool { skip + items.count < total }
    var nextSkip: Int { skip + items.count }
}
