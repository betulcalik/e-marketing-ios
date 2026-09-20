//
//  LoginViewModel.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 19.09.2026.
//

import Foundation

@Observable
final class LoginViewModel {
    
    var username = ""
    var password = ""
    
    private(set) var isSubmitting = false
    private(set) var errorMessage: String?
    
    var canSubmit: Bool {
        !trimmedUsername.isEmpty && !password.isEmpty && !isSubmitting
    }
    
    private let loginUseCase: LoginUseCaseProtocol
    private let onAuthenticated: (AuthSession) -> Void
    
    init(loginUseCase: LoginUseCaseProtocol,
         onAuthenticated: @escaping (AuthSession) -> Void) {
        self.loginUseCase = loginUseCase
        self.onAuthenticated = onAuthenticated
    }
    
    // MARK: - Actions
    func submit() async {
        guard canSubmit else {
            return
        }
        
        isSubmitting = true
        errorMessage = nil
        defer { isSubmitting = false }
        
        do {
            let session = try await loginUseCase.getAuthSession(
                username: trimmedUsername,
                password: password
            )
            onAuthenticated(session)
        } catch is CancellationError {
            // No error
        } catch let error as AppError {
            errorMessage = error.userMessage
        } catch {
            errorMessage = String(localized: "error.generic")
        }
    }
    
    func clearError() {
        errorMessage = nil
    }
}

// MARK: - Extensions
private extension LoginViewModel {
    var trimmedUsername: String {
        username.trimmingCharacters(in: .whitespaces)
    }
}
