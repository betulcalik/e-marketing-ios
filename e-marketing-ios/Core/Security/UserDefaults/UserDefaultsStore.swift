//
//  UserDefaultsStore.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 21.09.2026.
//

import Foundation

protocol UserDefaultsStoring: AnyObject {
    func string(forKey key: UserDefaultsKey) -> String?
    func set(_ value: String?, forKey key: UserDefaultsKey)
}

final class UserDefaultsStore: UserDefaultsStoring {

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func string(forKey key: UserDefaultsKey) -> String? {
        defaults.string(forKey: key.rawValue)
    }

    func set(_ value: String?, forKey key: UserDefaultsKey) {
        defaults.set(value, forKey: key.rawValue)
    }
}
