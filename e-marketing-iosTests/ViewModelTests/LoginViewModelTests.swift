//
//  LoginViewModelTests.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 22.09.2026.
//

import Testing
import Foundation
@testable import e_marketing_ios

@MainActor
@Suite("LoginViewModel Tests")
struct LoginViewModelTests {

    @Test("[LoginViewModel] Authenticated test")
    func submit_success_invokesOnAuthenticated() async {
        var authenticated: AuthSession?
        let viewModel = LoginViewModel(loginUseCase: MockLoginUseCase()) {
            authenticated = $0
        }
        viewModel.username = "emilys"
        viewModel.password = "emilyspass"

        await viewModel.submit()

        #expect(authenticated?.accessToken == "access-token")
        #expect(viewModel.error == nil)
    }

    @Test("[LoginViewModel] Invalid credentials error test")
    func submit_invalidCredentials_setsError() async {
        let useCase = MockLoginUseCase()
        useCase.result = .failure(AppError.clientError(statusCode: 400))
        let viewModel = LoginViewModel(loginUseCase: useCase) { _ in }
        viewModel.username = "emilys"
        viewModel.password = "wrong"

        await viewModel.submit()

        #expect(viewModel.error == .invalidCredentials)
    }

    @Test("[LoginViewModel] isSubmitting test")
    func submit_whileLoading_isSubmitting() async throws {
        let useCase = MockLoginUseCase()
        useCase.delay = .milliseconds(500)
        let viewModel = LoginViewModel(loginUseCase: useCase) { _ in }
        viewModel.username = "emilys"
        viewModel.password = "emilyspass"

        let task = Task { await viewModel.submit() }
        try await Task.sleep(for: .milliseconds(100))

        #expect(viewModel.isSubmitting)

        await task.value
        #expect(!viewModel.isSubmitting)
    }
}
