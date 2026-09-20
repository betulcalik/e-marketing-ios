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
    
    func updateUser(_ user: User) {
        session = AuthSession(accessToken: session?.accessToken ?? "",
                              refreshToken: session?.refreshToken ?? "",
                              user: user)
    }
    
    func restore() {
        guard let tokenPair = keychainTokenStore.read() else { return }
        isAuthenticated = true
        session = AuthSession(accessToken: tokenPair.accessToken,
                              refreshToken: tokenPair.refreshToken,
                              user: nil)
    }
}
