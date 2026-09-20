//
//  AppError.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 19.09.2026.
//

import Foundation

enum AppError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case invalidCredentials
    case clientError(statusCode: Int)
    case serverError(statusCode: Int)
    case decodingError
    case timeout
    case offline
    case unknown
}

// MARK: - Extensions
extension AppError {
    var userMessage: String {
        switch self {
        case .clientError(let statusCode):
            switch statusCode {
            case 400, 401:   String(localized: "auth.error.invalidCredentials")
            case 403:        String(localized: "error.forbidden")
            case 404:        String(localized: "error.notFound")
            case 429:        String(localized: "error.rateLimited")
            default:         String(localized: "error.generic")
            }
        case .serverError:
            String(localized: "error.server")
        case .timeout, .offline:
            String(localized: "error.connection")
        case .invalidCredentials:
            String(localized: "auth.error.invalidCredentials")
        case .invalidURL, .invalidResponse, .decodingError, .unknown:
            String(localized: "error.generic")
        }
    }
    
    var isSessionExpired: Bool {
        if case .clientError(401) = self { return true }
        return false
    }
}
