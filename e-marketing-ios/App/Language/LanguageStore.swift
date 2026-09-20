//
//  LanguageStore.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 21.09.2026.
//

import Foundation
import Observation

@Observable
final class LanguageStore {

    private(set) var locale: Locale

    private let storage: UserDefaultsStoring

    init(storage: UserDefaultsStoring) {
        self.storage = storage
        let code = storage.string(forKey: .appLanguage) ?? "en"
        self.locale = Locale(identifier: code)
    }

    func setLanguage(_ code: String) {
        guard code != locale.language.languageCode?.identifier else { return }
        storage.set(code, forKey: .appLanguage)
        locale = Locale(identifier: code)
    }
}
