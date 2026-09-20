//
//  LoginRepositoryImpl.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 19.09.2026.
//

import Foundation

final class LoginRepositoryImpl: LoginRepositoryProtocol {
    
    private let client: HTTPClientProtocol
    
    init(client: HTTPClientProtocol) {
        self.client = client
    }
    
    func login(username: String, password: String) async throws -> AuthSession {
        let endpoint = Endpoint(
            path: "auth/login",
            method: .post,
            body: LoginRequestDTO(username: username, password: password)
        )
        
        return try await client.send(endpoint, as: LoginResponseDTO.self).toDomain
    }
    
    func me() async throws -> User {
        let endpoint = Endpoint(path: "auth/me")
        return try await client.send(endpoint, as: UserResponseDTO.self).toDomain
    }
}
