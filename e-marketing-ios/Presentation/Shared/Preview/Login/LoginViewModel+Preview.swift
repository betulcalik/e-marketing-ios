//
//  LoginViewModel+Preview.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 19.09.2026.
//

import Foundation

#if DEBUG
extension LoginViewModel {
    static var preview: LoginViewModel {
        LoginViewModel(loginUseCase: MockLoginUseCase(),
                       onAuthenticated: { _ in })
    }
}
#endif
