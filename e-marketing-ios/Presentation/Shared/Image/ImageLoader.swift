//
//  ImageLoader.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 21.09.2026.
//

import SwiftUI

@Observable
final class ImageLoader {

    private let cache = NSCache<NSURL, UIImage>()

    func image(for url: URL?) async -> UIImage? {
        guard let url else { return nil }
        if let cached = cache.object(forKey: url as NSURL) { return cached }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let image = UIImage(data: data)?.preparingForDisplay()
            if let image { cache.setObject(image, forKey: url as NSURL) }
            return image
        } catch {
            return nil
        }
    }
}
