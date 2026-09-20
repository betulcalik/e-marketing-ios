//
//  BannerCard.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 20.09.2026.
//

import SwiftUI

struct BannerCard: View {

    let banner: Banner
    let action: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 10) {
                Text(banner.title)
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)

                Text(banner.subtitle)
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.85))
                    .lineLimit(2, reservesSpace: true)
                    .minimumScaleFactor(0.7)
                    .multilineTextAlignment(.leading)

                ctaButton
            }

            Spacer(minLength: 0)

            Image(systemName: banner.systemImage)
                .font(.system(size: 56, weight: .light))
                .foregroundStyle(.white.opacity(0.9))
                .padding(.trailing, 4)
        }
        .padding(20)
        .frame(height: 160, alignment: .leading)
        .background(
            ZStack(alignment: .topTrailing) {
                LinearGradient(colors: banner.colors,
                               startPoint: .topLeading, endPoint: .bottomTrailing)

                Circle()
                    .fill(.white.opacity(0.10))
                    .frame(width: 140, height: 140)
                    .offset(x: 40, y: -40)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .onTapGesture { action() }
    }
}

// MARK: - Subviews
private extension BannerCard {
    var ctaButton: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 6) {
                Text("home.banner.cta")
                    .font(.footnote.weight(.semibold))

                Image(systemName: "arrow.right")
                    .font(.caption.weight(.semibold))
            }
            .foregroundStyle(Color.accentColor)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(.white, in: Capsule())
        }
        .accessibilityIdentifier("home.banner.cta")
    }
}

// MARK: - Previews
#Preview("BannerCard") {
    BannerCard(
        banner: Banner(id: 0, title: "Mid-Season Sale", subtitle: "Up to 50% off on fashion",
                       systemImage: "sparkles", colors: [.indigo, .purple])
    ) { }
    .padding(24)
}
