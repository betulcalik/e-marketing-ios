//
//  UserDTO.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 20.09.2026.
//

import Foundation

struct UserResponseDTO: Decodable {
    let id: Int
    let username: String
    let email: String
    let firstName: String
    let lastName: String
    let image: String?
}

extension UserResponseDTO {

    var toDomain: User {
        User(
            id: id,
            username: username,
            email: email,
            firstName: firstName,
            lastName: lastName,
            image: image.flatMap(URL.init(string:))
        )
    }
}
