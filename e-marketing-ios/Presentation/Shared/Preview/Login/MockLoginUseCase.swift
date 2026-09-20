//
//  MockLoginUseCase.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 19.09.2026.
//
 
import Foundation

#if DEBUG
final class MockLoginUseCase: LoginUseCaseProtocol {
    func getAuthSession(username: String, password: String) async throws -> AuthSession {
        try await Task.sleep(for: .seconds(1))
        return AuthSession(
            accessToken: "mock-access-token",
            refreshToken: "mock-refresh-token",
            user: User(id: 1,
                       username: username,
                       email: "\(username)@example.com",
                       firstName: "Emily")
        )
    }
}
#endif
