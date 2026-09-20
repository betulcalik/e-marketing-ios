//
//  ProductRepositoryProtocol.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 20.09.2026.
//

import Foundation

protocol ProductRepositoryProtocol {
    func categories() async throws -> [String]
    // TODO: func products()
}
