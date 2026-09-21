//
//  AuthInterceptor.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 21.09.2026.
//

import Foundation

final class AuthInterceptor: RequestInterceptor {

    private let tokenStore: KeychainTokenStoring

    init(tokenStore: KeychainTokenStoring) {
        self.tokenStore = tokenStore
    }

    func intercept(_ request: inout URLRequest) {
        if let tokenPair = tokenStore.read() {
            request.setValue("Bearer \(tokenPair.accessToken)", forHTTPHeaderField: "Authorization")
        }
    }
}
