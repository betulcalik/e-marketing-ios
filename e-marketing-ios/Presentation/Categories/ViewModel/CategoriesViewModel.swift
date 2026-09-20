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
    private(set) var errorMessage: String?

    private let homeUseCase: HomeUseCaseProtocol

    init(homeUseCase: HomeUseCaseProtocol) {
        self.homeUseCase = homeUseCase
    }

    func load() async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            categories = try await homeUseCase.getCategories()
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
