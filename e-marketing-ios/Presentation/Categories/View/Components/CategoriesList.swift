//
//  CategoriesList.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 20.09.2026.
//

import SwiftUI

struct CategoriesList: View {

    let categories: [String]
    var action: (String) -> Void
    var seeAllAction: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            header

            CategoryTileGrid(categories: categories, action: action)
                .padding(.horizontal, 24)
        }
    }
}

// MARK: - Helpers
private extension CategoriesList {
    var header: some View {
        HStack {
            Text("home.section.categories")
                .font(.title3.bold())

            Spacer()

            Button {
                seeAllAction()
            } label: {
                HStack(spacing: 2) {
                    Text("home.categories.seeAll")
                    Image(systemName: "arrow.right")
                }
                .font(.subheadline.weight(.medium))
                .foregroundStyle(Color.accentColor)
            }
            .accessibilityIdentifier("home.categories.seeAll")
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - Previews
#if DEBUG
#Preview("CategoriesList") {
    CategoriesList(
        categories: ["beauty", "fragrances", "furniture", "groceries",
                     "laptops", "mens-shirts", "smartphones", "tablets"],
        action: { _ in },
        seeAllAction: { }
    )
    .padding(.vertical, 16)
    .background(Color(.screenBackground))
}
#endif
