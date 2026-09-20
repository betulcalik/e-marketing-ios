//
//  CategoryCard.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 20.09.2026.
//

import SwiftUI

struct CategoryCard: View {

    let category: String
    let backgroundColor: Color
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            VStack(spacing: 8) {
                Image(systemName: iconName)
                    .font(.title3)
                    .foregroundStyle(Color.accentColor)
                    .fixedSize()

                Text(category.categoryDisplayName)
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("home.category.\(category)")
    }
}

// MARK: - Helpers
private extension CategoryCard {
    var iconName: String {
        switch category {
        case "beauty", "skin-care": "sparkles"
        case "fragrances": "drop"
        case "furniture", "home-decoration": "house"
        case "groceries": "cart"
        case "laptops": "laptopcomputer"
        case "smartphones": "iphone.gen3"
        case "mobile-accessories": "cable.connector"
        case "mens-shirts", "womens-dresses", "womens-shoes", "mens-shoes", "tops": "tshirt"
        case "mens-watches", "womens-watches": "applewatch"
        case "womens-bags": "bag"
        case "womens-jewellery": "diamond"
        case "kitchen-accessories": "fork.knife"
        case "sports-accessories": "dumbbell"
        case "vehicle", "motorcycle": "car"
        case "sunglasses": "sunglasses"
        default: "square.grid.2x2"
        }
    }
}

#Preview {
    CategoryCard(category: "womens-bag", backgroundColor: .accent) { }
        .padding(24)
        .background(Color(.screenBackground))
}
