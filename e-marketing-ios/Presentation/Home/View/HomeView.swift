//
//  HomeView.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 20.09.2026.
//

import SwiftUI

struct HomeView: View {

    @Environment(AppSessionStore.self) private var appSession
    @Environment(AppRouter.self) private var router
    @State private var viewModel: HomeViewModel

    init(viewModel: HomeViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        content
            .toolbar(.hidden, for: .navigationBar)
            .background(Color(.screenBackground))
            .task { await viewModel.load() }
            .refreshable { await viewModel.load() }
    }
}

// MARK: - Extensions
extension HomeView {
    private var content: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                if viewModel.shouldShowLoading {
                    LoadingView()
                } else if viewModel.shouldShowError {
                    ErrorView(error: viewModel.error ?? .unknown,
                              identifier: "home.retry") {
                        Task { await viewModel.load() }
                    }
                    .frame(minHeight: 300)
                } else {
                    greetingHeader
                    bannersSection
                    categoriesSection
                    forYouSection
                }
            }
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
        }
        .scrollIndicators(.hidden)
    }

    // MARK: - Header
    private var greetingHeader: some View {
        VStack(alignment: .leading, spacing: 4) {
            greeting
                .font(.title2.bold())
            
            Text("home.greeting.subtitle")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 12)
    }
    
    // MARK: - Banners
    private var mockBanners: [Banner] {
        [
            Banner(id: 0, title: "home.banner.1.title", subtitle: "home.banner.1.subtitle \(50.formatted(.percent))",
                   systemImage: "sparkles", colors: [.indigo, .purple]),
            Banner(id: 1, title: "home.banner.2.title", subtitle: "home.banner.2.subtitle",
                   systemImage: "iphone.gen3", colors: [.indigo, .purple]),
            Banner(id: 2, title: "home.banner.3.title", subtitle: "home.banner.3.subtitle",
                   systemImage: "sofa", colors: [.indigo, .purple])
        ]
    }
    
    private var bannersSection: some View {
        BannerCarousel(banners: mockBanners) { _ in
            router.push(.products(category: nil))
        }
    }
    
    // MARK: - Categories
    private var categoriesSection: some View {
        CategoriesList(
            categories: Array(viewModel.categories.prefix(8)),
            action: { category in
                router.push(.products(category: category))
            },
            seeAllAction: {
                router.push(.categories)
            }
        )
    }
    
    // MARK: - Featured products
    private var forYouSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("home.section.forYou")
                .font(.title3.bold())
                .padding(.horizontal, 24)
            
            LazyVGrid(columns: [GridItem(.flexible())], spacing: 12) {
                ForEach(viewModel.featuredProducts) { product in
                    ProductCard(product: product) { }
                        .onTapGesture {
                            // TODO.
                        }
                }
            }
            .padding(.horizontal, 24)
        }
    }
    
    // MARK: - Helpers
    private var greeting: Text {
        guard let name = appSession.session?.user?.firstName, !name.isEmpty else {
            return Text("home.greeting.anonymous")
        }
        return Text("home.greeting.user \(name)")
    }
}

// MARK: - Previews
#Preview("Home") {
    HomeView(viewModel: .preview)
        .environment(AppSessionStore(keychainTokenStore: KeychainTokenStore()))
        .environment(AppRouter())
}
