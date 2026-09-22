//
//  ProductsViewModelTests.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 23.09.2026.
//


import Testing
import Foundation
@testable import e_marketing_ios

@MainActor
@Suite("ProductsViewModel Tests")
struct ProductsViewModelTests {

    @Test("[ProductsViewModel] Load first page test")
    func loadFirstPage_success_populatesList() async {
        let useCase = MockProductsUseCase()
        useCase.stubbedPage = .dummy(count: 10, total: 20, skip: 0)
        let viewModel = makeViewModel(useCase: useCase)

        await viewModel.loadFirstPage()

        #expect(viewModel.products.count == 10)
        #expect(viewModel.totalCount == 20)
        #expect(viewModel.isFinished == false)
    }

    @Test("[ProductsViewModel] LoadMoreIfNeeded triggers only for the last product test")
    func loadMoreIfNeeded_lastProduct_fetchesNextPage() async {
        let useCase = MockProductsUseCase()
        useCase.stubbedPage = .dummy(count: 10, total: 20, skip: 0)
        let viewModel = makeViewModel(useCase: useCase)
        await viewModel.loadFirstPage()

        await viewModel.loadMoreIfNeeded(current: viewModel.products.last!)

        #expect(useCase.callCount == 2)
    }

    @Test("[ProductsViewModel] LoadMoreIfNeeded ignores non-last products test")
    func loadMoreIfNeeded_notLastProduct_makesNoRequest() async {
        let useCase = MockProductsUseCase()
        useCase.stubbedPage = .dummy(count: 10, total: 20, skip: 0)
        let viewModel = makeViewModel(useCase: useCase)
        await viewModel.loadFirstPage()

        await viewModel.loadMoreIfNeeded(current: viewModel.products.first!)

        #expect(useCase.callCount == 1)
    }

    @Test("[ProductsViewModel] After the last page no further requests are made test")
    func loadMore_afterLastPage_makesNoRequest() async {
        let useCase = MockProductsUseCase()
        useCase.stubbedPage = .dummy(count: 10, total: 10, skip: 0)
        let viewModel = makeViewModel(useCase: useCase)
        await viewModel.loadFirstPage()

        await viewModel.loadMoreIfNeeded(current: viewModel.products.last!)

        #expect(useCase.callCount == 1)
        #expect(viewModel.isFinished)
    }

    @Test("[ProductsViewModel] Unauthorized triggers session expiry test")
    func loadFirstPage_unauthorized_invokesSessionExpired() async {
        let useCase = MockProductsUseCase()
        useCase.stubbedError = AppError.clientError(statusCode: 401)
        var sessionExpiredCount = 0
        let viewModel = ProductsViewModel(category: nil, productsUseCase: useCase) {
            sessionExpiredCount += 1
        }

        await viewModel.loadFirstPage()

        #expect(sessionExpiredCount == 1)
    }
}

private extension ProductsViewModelTests {

    func makeViewModel(useCase: MockProductsUseCase) -> ProductsViewModel {
        ProductsViewModel(category: nil, productsUseCase: useCase) { }
    }
}
