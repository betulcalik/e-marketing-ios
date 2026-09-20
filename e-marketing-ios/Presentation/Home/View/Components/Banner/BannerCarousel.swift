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

/// Horizontally paged campaign banner carousel
struct BannerCarousel: View {

    let banners: [Banner]
    var action: (Banner) -> Void = { _ in }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(banners) { banner in
                    card(banner)
                        .frame(width: 300)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .contentMargins(.horizontal, 12, for: .scrollContent)
    }
}

// MARK: - Card
extension BannerCarousel {
    private func card(_ banner: Banner) -> some View {
        Button {
            action(banner)
        } label: {
            ZStack(alignment: .bottomLeading) {
                LinearGradient(colors: banner.colors,
                               startPoint: .topLeading, endPoint: .bottomTrailing)

                Circle()
                    .fill(.white.opacity(0.12))
                    .frame(width: 150, height: 150)
                    .offset(x: 190, y: -50)
                Circle()
                    .fill(.white.opacity(0.08))
                    .frame(width: 80, height: 80)
                    .offset(x: -20, y: 110)

                VStack(alignment: .leading, spacing: 6) {
                    Image(systemName: banner.systemImage)
                        .font(.title2)

                    Text(banner.title)
                        .font(.title3.bold())
                        .lineLimit(2, reservesSpace: true)
                        .minimumScaleFactor(0.7)
                        .multilineTextAlignment(.leading)

                    Text(banner.subtitle)
                        .font(.footnote)
                        .foregroundStyle(.white.opacity(0.85))
                        .lineLimit(2, reservesSpace: true)
                        .minimumScaleFactor(0.7)
                        .multilineTextAlignment(.leading)
                }
                .foregroundStyle(.white)
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .accessibilityElement(children: .combine)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Previews
#Preview {
    BannerCarousel(banners: [
        Banner(id: 0, title: "Mid-Season Sale", subtitle: "Up to 50% off on fashion",
               systemImage: "sparkles", colors: [.indigo, .purple]),
        Banner(id: 1, title: "New Arrivals", subtitle: "Fresh tech, fresh looks",
               systemImage: "iphone.gen3", colors: [.blue, .cyan])
    ])
    .padding(.vertical, 24)
}
