//
//  RemoteImage.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 21.09.2026.
//

import SwiftUI

struct RemoteImage: View {

    @Environment(ImageLoader.self) private var imageLoader

    let url: URL?
    @State private var image: UIImage?

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Color(.systemGray5)
            }
        }
        .task(id: url) {
            image = await imageLoader.image(for: url)
        }
    }
}
