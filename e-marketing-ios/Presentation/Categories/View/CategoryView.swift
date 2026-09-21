//
//  CategoryView.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 20.09.2026.
//

import SwiftUI

/// All categories page - reached from Home's "See All"
struct CategoriesView: View {

    @Environment(AppRouter.self) private var router
    @State private var viewModel: CategoriesViewModel

    init(viewModel: CategoriesViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        content
            .navigationTitle("categories.title")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.screenBackground))
            .task { await viewModel.load() }
    }
}

// MARK: - Extensions
extension CategoriesView {

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading, viewModel.categories.isEmpty {
            LoadingView()
        } else if viewModel.categories.isEmpty, viewModel.error != nil {
            ErrorView(error: viewModel.error ?? .unknown, identifier: "categories.retry") {
                Task { await viewModel.load() }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            ScrollView {
                CategoryTileGrid(categories: viewModel.categories) { category in
                    router.push(.products(category: category))
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
            }
        }
    }
}

// MARK: - Previews
#if DEBUG
#Preview("Categories") {
    NavigationStack {
        CategoriesView(viewModel: .preview)
    }
    .previewAppEnvironment()
}
#endif
