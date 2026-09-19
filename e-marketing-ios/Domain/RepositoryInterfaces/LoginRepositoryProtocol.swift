//
//  LoginRepository.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 19.09.2026.
//

protocol LoginRepositoryProtocol {
    func login(username: String, password: String) async throws -> AuthSession
}
