//
//  LanguagePicker.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 21.09.2026.
//

import SwiftUI

struct LanguagePicker: View {

    @Environment(LanguageStore.self) private var language

    var body: some View {
        Menu {
            option("Türkçe", code: "tr")
            option("English", code: "en")
        } label: {
            HStack(spacing: 6) {
                Text(currentCode.uppercased())
                    .font(.subheadline.weight(.semibold))
                Image(systemName: "globe")
            }
            .foregroundStyle(Color.accentColor)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Capsule().fill(Color(.systemBackground)))
            .overlay(Capsule().strokeBorder(Color(.systemGray4)))
        }
        .accessibilityIdentifier("profile.language.menu")
    }
}

// MARK: - Extensions
extension LanguagePicker {

    private var currentCode: String {
        language.locale.language.languageCode?.identifier ?? "en"
    }

    @ViewBuilder
    private func option(_ title: LocalizedStringKey, code: String) -> some View {
        Button {
            language.setLanguage(code)
        } label: {
            if currentCode == code {
                Label(title, systemImage: "checkmark")
            } else {
                Text(title)
            }
        }
    }
}

// MARK: - Previews
#Preview("LanguagePicker") {
    LanguagePicker()
        .environment(LanguageStore(storage: UserDefaultsStore()))
        .padding(24)
}
