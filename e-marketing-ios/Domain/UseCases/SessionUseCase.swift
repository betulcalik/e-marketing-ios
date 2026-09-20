//
//  SessionUseCase.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 20.09.2026.
//

import Foundation

protocol SessionUseCaseProtocol: AnyObject {
    func getCurrentUser() async throws -> User
}

final class SessionUseCase: SessionUseCaseProtocol {

    private let loginRepository: LoginRepositoryProtocol

    init(loginRepository: LoginRepositoryProtocol) {
        self.loginRepository = loginRepository
    }

    func getCurrentUser() async throws -> User {
        try await loginRepository.me()
    }
}
