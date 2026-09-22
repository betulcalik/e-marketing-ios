//
//  CategoryTileGrid.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 20.09.2026.
//

import SwiftUI

struct CategoryTileGrid: View {

    let categories: [String]
    var identifierPrefix: String = "home.category."
    let action: (String) -> Void

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(categories, id: \.self) { category in
                CategoryCard(category: category, backgroundColor: .categoryBackground,
                              identifierPrefix: identifierPrefix) {
                    action(category)
                }
            }
        }
    }
}
