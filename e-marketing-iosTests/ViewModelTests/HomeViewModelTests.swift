//
//  HomeViewModelTests.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 23.09.2026.
//


import Testing
import Foundation
@testable import e_marketing_ios

@MainActor
@Suite("HomeViewModel Tests")
struct HomeViewModelTests {

    @Test("[HomeViewModel] Load categories and featured products test")
    func load_success_populatesSections() async {
        let useCase = MockHomeUseCase()
        useCase.stubbedCategories = ["beauty", "laptops"]
        useCase.stubbedFeatured = [.dummy]
        let viewModel = HomeViewModel(homeUseCase: useCase)

        await viewModel.load()

        #expect(viewModel.categories == ["beauty", "laptops"])
        #expect(viewModel.featuredProducts.count == 1)
        #expect(viewModel.error == nil)
    }

    @Test("[HomeViewModel] AppError offline test")
    func load_failure_setsError() async {
        let useCase = MockHomeUseCase()
        useCase.stubbedError = AppError.offline
        let viewModel = HomeViewModel(homeUseCase: useCase)

        await viewModel.load()

        #expect(viewModel.error == .offline)
    }

    @Test("[HomeViewModel] LoadIfNeeded test")
    func loadIfNeeded_withContent_skipsFetch() async {
        let useCase = MockHomeUseCase()
        useCase.stubbedCategories = ["beauty"]
        let viewModel = HomeViewModel(homeUseCase: useCase)

        await viewModel.loadIfNeeded()
        await viewModel.loadIfNeeded()

        #expect(useCase.callCount == 2)
    }
}
