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
    private(set) var isSubmitting = false
    private(set) var errorMessage: String?

    var shouldShowContent: Bool { !categories.isEmpty }
    var shouldShowLoading: Bool { categories.isEmpty && isSubmitting }
    var shouldShowError: Bool { categories.isEmpty && errorMessage != nil }

    private let homeUseCase: HomeUseCaseProtocol

    init(homeUseCase: HomeUseCaseProtocol) {
        self.homeUseCase = homeUseCase
    }

    // MARK: - Actions
    func load() async {
        guard !isSubmitting else { return }

        isSubmitting = true
        errorMessage = nil
        defer { isSubmitting = false }

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
