//
//  CategoriesViewModel.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 20.09.2026.
//

import Foundation
import Observation

@Observable
final class CategoriesViewModel {

    private(set) var categories: [String] = []
    private(set) var isLoading = false
    private(set) var error: AppError?
    private(set) var retryCount = 0

    private let homeUseCase: HomeUseCaseProtocol

    init(homeUseCase: HomeUseCaseProtocol) {
        self.homeUseCase = homeUseCase
    }

    func load() async {
        guard !isLoading else { return }

        isLoading = true
        error = nil
        defer { isLoading = false }

        do {
            categories = try await homeUseCase.getCategories()
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
