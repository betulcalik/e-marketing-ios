//
//  ProductsList.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 20.09.2026.
//

import SwiftUI

struct ProductsList: View {

    let products: [Product]
    var isLoadingMore: Bool = false
    var onProductAppear: (Product) -> Void = { _ in }
    var onAddToCart: (Product) -> Void = { _ in }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(products) { product in
                    ProductCard(product: product) {
                        onAddToCart(product)
                    }
                    .onAppear {
                        onProductAppear(product)
                    }
                }

                if isLoadingMore {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .scrollIndicators(.hidden)
        .background(Color(.screenBackground))
    }
}

#Preview {
    ProductsList(
        products: (1...8).map { i in
            Product(id: i, title: "Product #\(i)", thumbnail: nil,
                    price: Double(i) * 999, discountPercentage: 10,
                    rating: 4.5, category: "smartphones")
        },
        isLoadingMore: true
    )
}
