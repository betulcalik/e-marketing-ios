//
//  LoginResponseDTO+Mapping.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 19.09.2026.
//

import Foundation

extension LoginResponseDTO {
    var toDomain: AuthSession {
        AuthSession(
            accessToken: accessToken,
            refreshToken: refreshToken,
            user: User(
                id: id,
                username: username,
                email: email
            )
        )
    }
}
