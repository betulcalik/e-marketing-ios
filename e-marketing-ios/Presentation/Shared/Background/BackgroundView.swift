//
//  BackgroundView.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 20.09.2026.
//

import SwiftUI

struct BackgroundView: View {

    var colors: [Color] = [.indigo, .purple]
    var startPoint: UnitPoint = .top
    var endPoint: UnitPoint = .bottom

    var body: some View {
        LinearGradient(colors: colors, startPoint: startPoint, endPoint: endPoint)
            .ignoresSafeArea()
    }
}

// MARK: - Previews
#if DEBUG
#Preview("Default (brand)") {
    BackgroundView()
}

#Preview("Custom colors") {
    BackgroundView(colors: [.teal, .mint],
                   startPoint: .topLeading,
                   endPoint: .bottomTrailing)
}
#endif
