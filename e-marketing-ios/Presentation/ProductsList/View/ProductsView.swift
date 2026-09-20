//
//  ProductsView.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 20.09.2026.
//

import SwiftUI

struct ProductsView: View {

    @State private var viewModel: ProductsViewModel

    init(viewModel: ProductsViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        content
            .navigationTitle(viewModel.category?.categoryDisplayName ?? String(localized: "products.title"))
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.screenBackground))
            .task { await viewModel.loadFirstPage() }
            .refreshable { await viewModel.loadFirstPage() }
            .errorAlert(
                message: viewModel.products.isEmpty ? nil : viewModel.errorMessage,
                onDismiss: viewModel.clearError
            )
    }
}

// MARK: - Extensions
extension ProductsView {

    @ViewBuilder
    private var content: some View {
        if viewModel.shouldShowLoading {
            LoadingView()
        } else if viewModel.shouldShowError {
            ErrorView(message: viewModel.errorMessage ?? "", identifier: "products.retry") {
                Task { await viewModel.loadFirstPage() }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            ProductsList(
                products: viewModel.products,
                isLoadingMore: viewModel.isLoadingMore,
                onProductAppear: { product in
                    Task { await viewModel.loadMoreIfNeeded(current: product) }
                },
                onAddToCart: { _ in
                    // TODO: Add to cart
                }
            )
        }
    }
}

// MARK: - Previews
#Preview("Products") {
    ProductsView(viewModel: .preview)
}
