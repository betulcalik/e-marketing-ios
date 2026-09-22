//
//  AppSessionStoreTests.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 23.09.2026.
//

import Testing
import Foundation
@testable import e_marketing_ios

@MainActor
@Suite("AppSessionStore Tests")
struct AppSessionStoreTests {

    @Test("[AppSessionStore] Save token pair & authenticate")
    func login_savesTokenPair_andAuthenticates() {
        let keychain = MockKeychainTokenStore()
        let store = AppSessionStore(keychainTokenStore: keychain)

        store.login(session: AuthSession(accessToken: "access-token",
                                         refreshToken: "refresh-token",
                                         user: nil))

        #expect(keychain.savedPair?.accessToken == "access-token")
        #expect(keychain.savedPair?.refreshToken == "refresh-token")
        #expect(store.isAuthenticated)
    }

    @Test("[AppSessionstore] Delete token pair & clear session")
    func logout_deletesToken_andClearsSession() {
        let keychain = MockKeychainTokenStore()
        let store = AppSessionStore(keychainTokenStore: keychain)
        store.login(session: AuthSession(accessToken: "a", refreshToken: "r", user: nil))

        store.logout()

        #expect(keychain.deleteCount == 1)
        #expect(store.isAuthenticated == false)
        #expect(store.session == nil)
    }

    @Test("[AppSessionStore] Restore token pair")
    func restore_readsTokenPair_fromKeychain() {
        let keychain = MockKeychainTokenStore()
        keychain.stubbedPair = TokenPair(accessToken: "a", refreshToken: "r")
        let store = AppSessionStore(keychainTokenStore: keychain)

        store.restore()

        #expect(store.isAuthenticated)
        #expect(store.session?.refreshToken == "r")
    }
}
