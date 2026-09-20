//
//  LoadingView.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 20.09.2026.
//

import SwiftUI

struct LoadingView: View {

    var message: LocalizedStringKey? = nil

    var body: some View {
        VStack(spacing: 12) {
            ProgressView()

            if let message {
                Text(message)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Previews
#Preview {
    LoadingView()
    
    LoadingView(message: "common.loading")
}
