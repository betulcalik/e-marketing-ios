//
//  KeychainTokenStore.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 20.09.2026.
//

import Foundation

final class KeychainTokenStore: KeychainTokenStoring {

    private let keychain: KeychainStore
    private let key = "token-pair"

    init(keychain: KeychainStore = KeychainStore()) {
        self.keychain = keychain
    }

    func save(_ pair: TokenPair) {
        guard let data = try? JSONEncoder().encode(pair) else { return }
        keychain.save(data, for: key)
    }

    func read() -> TokenPair? {
        keychain.readData(for: key).flatMap {
            try? JSONDecoder().decode(TokenPair.self, from: $0)
        }
    }

    func delete() {
        keychain.deleteData(for: key)
    }
}
