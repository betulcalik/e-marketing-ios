//
//  BannerCarousel.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 20.09.2026.
//

import SwiftUI

struct Banner: Identifiable {
    let id: Int
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey
    let systemImage: String
    let colors: [Color]
}

struct BannerCarousel: View {

    let banners: [Banner]
    var action: (Banner) -> Void = { _ in }

    @State private var currentIndex: Int? = 0

    var body: some View {
        VStack(spacing: 10) {
            scrollView
            pageDots
        }
        .task { await autoAdvance() }
    }
}

// MARK: - Extensions
private extension BannerCarousel {
    var scrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(banners) { banner in
                    BannerCard(banner: banner) {
                        action(banner)
                    }
                    .frame(width: 340)
                    .id(banner.id)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .scrollPosition(id: $currentIndex, anchor: .leading)
        .contentMargins(.horizontal, 12, for: .scrollContent)
    }

    var pageDots: some View {
        HStack(spacing: 6) {
            ForEach(banners) { banner in
                Circle()
                    .fill(banner.id == currentIndex ? Color.accentColor : Color(.systemGray3))
                    .frame(width: 6, height: 6)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentIndex = banner.id
                        }
                    }
            }
        }
    }

    func autoAdvance() async {
        while !Task.isCancelled {
            try? await Task.sleep(for: .seconds(4))
            guard !Task.isCancelled, !banners.isEmpty else { return }

            withAnimation(.easeInOut(duration: 0.4)) {
                currentIndex = ((currentIndex ?? 0) + 1) % banners.count
            }
        }
    }
}

// MARK: - Previews
#Preview {
    BannerCarousel(banners: [
        Banner(id: 0, title: "Mid-Season Sale", subtitle: "Up to 50% off on fashion",
               systemImage: "sparkles", colors: [.indigo, .purple]),
        Banner(id: 1, title: "New Arrivals", subtitle: "Fresh tech, fresh looks",
               systemImage: "iphone.gen3", colors: [.blue, .cyan]),
        Banner(id: 2, title: "Home & Living", subtitle: "Cozy up for less",
               systemImage: "sofa", colors: [.orange, .pink])
    ])
    .padding(.vertical, 24)
}
