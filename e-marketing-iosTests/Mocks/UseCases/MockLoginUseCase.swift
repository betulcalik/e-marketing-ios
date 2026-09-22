//
//  MockLoginUseCase.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 22.09.2026.
//

import Foundation
@testable import e_marketing_ios

@MainActor
final class MockLoginUseCase: LoginUseCaseProtocol {

    var result: Result<AuthSession, Error> = .success(
        AuthSession(accessToken: "access-token", refreshToken: "refresh-token", user: nil)
    )
    var delay: Duration?

    private(set) var callCount = 0

    func getAuthSession(username: String, password: String) async throws -> AuthSession {
        callCount += 1

        if let delay {
            try? await Task.sleep(for: delay)
        }

        switch result {
        case .success(let session):
            return session
        case .failure(let error):
            throw error
        }
    }
}
