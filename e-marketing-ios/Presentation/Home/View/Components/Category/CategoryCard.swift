//
//  CategoryCard.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 20.09.2026.
//

import SwiftUI

struct CategoryCard: View {

    let category: String
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            HStack( spacing: 12) {
                Image(systemName: iconName)
                    .font(.title3)
                    .foregroundStyle(.tint)
                    .frame(width: 44, height: 44)
                    .background(Color.accentColor.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Text(displayName)
                    .font(.subheadline.weight(.bold))
                    .lineLimit(1)
                    .foregroundStyle(.primary)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(Color(.systemGray4), lineWidth: 1)
            }
            .overlay(alignment: .trailing) {
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.tertiary)
                    .padding(.trailing, 14)
            }
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("home.category.\(category)")
    }
}

// MARK: - Helpers
private extension CategoryCard {
    var displayName: String {
        category.split(separator: "-").map(\.capitalized).joined(separator: " ")
    }

    var iconName: String {
        switch category {
        case "beauty": "sparkles"
        case "fragrances": "drop"
        case "furniture": "sofa"
        case "groceries": "cart"
        case "laptops": "laptopcomputer"
        case "smartphones": "iphone.gen3"
        case "mobile-accessories": "cable.connector"
        case "mens-shirts", "womens-dresses", "womens-shoes", "mens-shoes": "tshirt"
        case "mens-watches", "womens-watches": "applewatch"
        case "womens-bags": "bag"
        case "home-decoration": "lamp.desk"
        case "kitchen-accessories": "fork.knife"
        default: "square.grid.2x2"
        }
    }
}

#Preview {
    CategoryCard(category: "womens-bag") { }
        .padding(24)
        .background(Color(.systemGroupedBackground))
}
