//
//  HomeViewModel.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 20.09.2026.
//

import Foundation

@Observable
final class HomeViewModel {

    private(set) var categories: [String] = []
    private(set) var featuredProducts: [Product] = []
    
    private(set) var isSubmitting = false
    private(set) var error: AppError?
    private(set) var retryCount = 0

    var shouldShowContent: Bool { !categories.isEmpty }
    var shouldShowLoading: Bool { categories.isEmpty && isSubmitting }
    var shouldShowError: Bool { categories.isEmpty && error != nil }

    private let homeUseCase: HomeUseCaseProtocol

    init(homeUseCase: HomeUseCaseProtocol) {
        self.homeUseCase = homeUseCase
    }

    // MARK: - Actions
    func load() async {
        guard !isSubmitting else { return }

        isSubmitting = true
        error = nil
        defer { isSubmitting = false }

        do {
            async let categoriesTask = homeUseCase.getCategories()
            async let featuredTask = homeUseCase.getFeaturedProducts()
            
            categories = try await categoriesTask
            featuredProducts = try await featuredTask
        } catch is CancellationError {
            // No error
        } catch let error as AppError {
            self.error = error
        } catch {
            self.error = .unknown
        }
    }

    func loadIfNeeded() async {
        guard categories.isEmpty else { return }
        await load()
    }

    func retry() {
        retryCount += 1
    }

    func clearError() {
        error = nil
    }
}
