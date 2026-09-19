//
//  LoginDTO.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 19.09.2026.
//

import Foundation

struct LoginRequestDTO: Encodable {
    let username: String
    let password: String
}

struct LoginResponseDTO: Decodable {
    let accessToken: String?
    let refreshToken: String?
    let id: Int?
    let username: String?
    let email: String?
    let firstName: String?
    let lastName: String?
    let image: String?
}
