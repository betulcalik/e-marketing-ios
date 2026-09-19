//
//  KeychainTokenStoring.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 20.09.2026.
//

import Foundation

struct TokenPair: Codable, Equatable {
    let accessToken: String
    let refreshToken: String
}

protocol KeychainTokenStoring {
    func save(_ pair: TokenPair)
    func read() -> TokenPair?
    func delete()
}
