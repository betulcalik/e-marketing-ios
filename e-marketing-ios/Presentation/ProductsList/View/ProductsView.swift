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
            errorRetryView
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

    private var errorRetryView: some View {
        VStack(spacing: 16) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)
            Text(viewModel.errorMessage ?? "")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            AppButton(title: "home.error.retry", identifier: "products.retry") {
                Task { await viewModel.loadFirstPage() }
            }
            .padding(.horizontal, 48)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 24)
    }
}

// MARK: - Previews
#Preview("Products") {
    ProductsView(viewModel: .preview)
}
