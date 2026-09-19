//
//  LoginUseCase.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 19.09.2026.
//

protocol LoginUseCaseProtocol: AnyObject {
    func getAuthSession(username: String, password: String) async throws -> AuthSession
}

final class LoginUseCase: LoginUseCaseProtocol {
    private let loginRepository: LoginRepositoryProtocol
    
    init(loginRepository: LoginRepositoryProtocol) {
        self.loginRepository = loginRepository
    }
    
    func getAuthSession(username: String, password: String) async throws -> AuthSession {
        try await loginRepository.login(username: username, password: password)
    }
}
