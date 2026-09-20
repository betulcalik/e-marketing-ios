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
                } else {
                    greetingHeader
                    bannersSection
                    categoriesSection
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
            Text(greeting)
                .font(.title2.bold())
            
            Text("home.greeting.subtitle")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Spacer()
            logoutButton
        }
        .padding(.horizontal, 12)
    }
    
    private var logoutButton: some View {
        Button {
            appSession.logout()
            router.reset()
        } label: {
            Image(systemName: "rectangle.portrait.and.arrow.right")
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .accessibilityIdentifier("home.logout")
        .accessibilityLabel(Text("home.logout.title"))
    }
    
    // MARK: - Banners
    private var mockBanners: [Banner] {
        [
            Banner(id: 0, title: "home.banner.1.title", subtitle: "home.banner.1.subtitle \(50.formatted(.percent))",
                   systemImage: "sparkles", colors: [.indigo, .purple]),
            Banner(id: 1, title: "home.banner.2.title", subtitle: "home.banner.2.subtitle",
                   systemImage: "iphone.gen3", colors: [.blue, .cyan]),
            Banner(id: 2, title: "home.banner.3.title", subtitle: "home.banner.3.subtitle",
                   systemImage: "sofa", colors: [.orange, .pink])
        ]
    }
    
    private var bannersSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("home.section.banners")
                .font(.title3.bold())
                .padding(.horizontal, 12)

            BannerCarousel(banners: mockBanners) { _ in
                router.push(.products(category: nil))
            }
        }
    }
    
    // MARK: - Categories
    private var categoriesSection: some View {
        CategoriesList(categories: viewModel.categories) { category in
            router.push(.products(category: category))
        }
    }
    
    // MARK: - Helpers
    private var greeting: String {
        guard let name = appSession.session?.user?.firstName, !name.isEmpty else {
            return String(localized: "home.greeting.anonymous")
        }
        return String(localized: "home.greeting.user \(name)")
    }
}

// MARK: - Previews
#Preview("Home") {
    HomeView(viewModel: .preview)
        .environment(AppSessionStore(keychainTokenStore: KeychainTokenStore()))
        .environment(AppRouter())
}
