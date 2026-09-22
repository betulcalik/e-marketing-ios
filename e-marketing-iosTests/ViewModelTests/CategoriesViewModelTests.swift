//
//  CategoriesViewModelTests.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 23.09.2026.
//


import Testing
import Foundation
@testable import e_marketing_ios

@MainActor
@Suite("CategoriesViewModel Tests")
struct CategoriesViewModelTests {

    @Test("[CategoriesViewModel] Load categories test")
    func load_success_populatesCategories() async {
        let useCase = MockHomeUseCase()
        useCase.stubbedCategories = ["beauty", "fragrances", "laptops"]
        let viewModel = CategoriesViewModel(homeUseCase: useCase)

        await viewModel.load()

        #expect(viewModel.categories.count == 3)
    }

    @Test("[CategoriesViewModel] AppError 500 test")
    func load_failure_setsError() async {
        let useCase = MockHomeUseCase()
        useCase.stubbedError = AppError.serverError(statusCode: 500)
        let viewModel = CategoriesViewModel(homeUseCase: useCase)

        await viewModel.load()

        #expect(viewModel.error == .serverError(statusCode: 500))
    }
}
