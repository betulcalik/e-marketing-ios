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
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.screenBackground))
            .task { await viewModel.loadFirstPage() }
            .refreshable { await viewModel.loadFirstPage() }
            .errorAlert(
                error: viewModel.products.isEmpty ? nil : viewModel.error,
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
            ErrorView(error: viewModel.error ?? .unknown, identifier: "products.retry") {
                Task { await viewModel.loadFirstPage() }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            VStack(spacing: 12) {
                if let total = viewModel.totalCount {
                    Text("products.total \(total)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                }
                
                ProductsList(
                    products: viewModel.products,
                    isLoadingMore: viewModel.isLoadingMore,
                    onProductAppear: { product in
                        Task { await viewModel.loadMoreIfNeeded(current: product) }
                    },
                    onAddToCart: { _ in }
                )
            }
        }
    }
    
    private var navigationTitle: Text {
        if let category = viewModel.category {
            return Text(verbatim: category.categoryDisplayName)
        }
        return Text("products.title")
    }
}

// MARK: - Previews
#Preview("Products") {
    ProductsView(viewModel: .preview)
}
