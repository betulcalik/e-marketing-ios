//
//  MockKeychainStore.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 22.09.2026.
//

import Foundation
@testable import e_marketing_ios

@MainActor
final class MockKeychainTokenStore: KeychainTokenStoring {

    var stubbedPair: TokenPair?

    private(set) var savedPair: TokenPair?
    private(set) var deleteCount = 0

    func save(_ pair: TokenPair) {
        savedPair = pair
    }

    func read() -> TokenPair? {
        stubbedPair
    }

    func delete() {
        deleteCount += 1
    }
}
