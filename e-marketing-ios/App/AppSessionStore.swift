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

    // MARK: - State
    private(set) var isAuthenticated = false
    private(set) var session: AuthSession?

    // MARK: - Actions
    func login(session: AuthSession) {
        self.session = session
        isAuthenticated = true
    }

    func logout() {
        session = nil
        isAuthenticated = false
    }
}
