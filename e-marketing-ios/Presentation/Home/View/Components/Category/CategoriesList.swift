//
//  CategoriesList.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 20.09.2026.
//

import SwiftUI

/// Vertically stacked, lazily rendered category cards.
struct CategoriesList: View {

    let categories: [String]
    let action: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("home.section.categories")
                .font(.title3.bold())
                .padding(.horizontal, 12)

            LazyVStack(spacing: 6) {
                ForEach(categories, id: \.self) { category in
                    CategoryCard(category: category) {
                        action(category)
                    }
                    .padding(.horizontal, 12)
                }
            }
        }
    }
}

// MARK: - Previews
#if DEBUG
#Preview("CategoriesList") {
    CategoriesList(categories: ["beauty", "fragrances", "laptops", "smartphones"]) { _ in }
        .padding(.vertical, 16)
        .background(Color(.systemGroupedBackground))
}
#endif
