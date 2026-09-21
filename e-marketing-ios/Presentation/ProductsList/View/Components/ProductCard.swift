//
//  ProductCard.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 20.09.2026.
//

import SwiftUI

/// Product list card: thumbnail, title, subtitle, rating, price and cart action.
struct ProductCard: View {

    let product: Product
    var onAddToCart: () -> Void = { }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            thumbnailView

            VStack(alignment: .leading, spacing: 6) {
                Text(product.title)
                    .font(.subheadline.weight(.bold))
                    .lineLimit(1)
                    .foregroundStyle(.primary)

                Text(categoryName)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                ratingView

                Spacer(minLength: 0)

                Text(product.price, format: .currency(code: "TRY"))
                    .font(.headline)
                    .foregroundStyle(Color.accentColor)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(minHeight: 108, alignment: .top)
        .overlay(alignment: .bottomTrailing) {
            cartButton
        }
        .padding(12)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Extensions
private extension ProductCard {

    var thumbnailView: some View {
        RemoteImage(url: product.thumbnail)
        .frame(width: 84, height: 84)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    var ratingView: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .font(.caption2)
                .foregroundStyle(.orange)

            Text(product.rating, format: .number.precision(.fractionLength(1)))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    var cartButton: some View {
        Button(action: onAddToCart) {
            Image(systemName: "cart")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: 36, height: 36)
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .accessibilityIdentifier("product.addToCart.\(product.id)")
    }

    var categoryName: String {
        product.category.categoryDisplayName
    }
}

// MARK: - Previews
#Preview {
    ProductCard(
        product: Product(
            id: 1,
            title: "iPhone 16",
            thumbnail: URL(string: "https://cdn.dummyjson.com/product-images/smartphones/iphone-x/thumbnail.webp"),
            price: 42999,
            discountPercentage: 10,
            rating: 4.8,
            category: "smartphones"
        )
    )
    .padding(24)
    .background(Color(.screenBackground))
    .previewAppEnvironment()
}
