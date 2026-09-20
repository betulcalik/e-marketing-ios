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
    
    var messageKey: String {
        switch self {
        case .invalidCredentials:
            return "auth.error.invalidCredentials"
        case .clientError(let statusCode):
            switch statusCode {
            case 400:   return "error.badRequest"
            case 401:   return "error.unauthorized"
            case 403:   return "error.forbidden"
            case 404:   return "error.notFound"
            case 429:   return "error.rateLimited"
            default:    return "error.generic"
            }
        case .serverError:
            return "error.server"
        case .timeout:
            return "error.timeout"
        case .offline:
            return "error.connection"
        case .invalidURL, .invalidResponse, .decodingError, .unknown:
            return "error.generic"
        }
    }
    
    var isSessionExpired: Bool {
        if case .clientError(401) = self { return true }
        return false
    }
}
