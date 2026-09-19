//
//  AppSession.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 19.09.2026.
//

import Foundation
import Observation

@Observable
final class AppSessionStore {

    private let keychainTokenStore: KeychainTokenStoring
    private(set) var isAuthenticated = false
    private(set) var session: AuthSession?
    
    init(keychainTokenStore: KeychainTokenStoring) {
        self.keychainTokenStore = keychainTokenStore
    }

    // MARK: - Actions
    func login(session: AuthSession) {
        self.session = session
        keychainTokenStore.save(TokenPair(
            accessToken: session.accessToken,
            refreshToken: session.refreshToken
        ))
        isAuthenticated = true
    }

    func logout() {
        keychainTokenStore.delete()
        session = nil
        isAuthenticated = false
    }
    
    func restore() {
        guard keychainTokenStore.read() != nil else { return }
        isAuthenticated = true
    }
}
