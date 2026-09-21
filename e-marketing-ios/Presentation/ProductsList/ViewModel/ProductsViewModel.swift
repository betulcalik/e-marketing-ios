//
//  ProductsViewModel.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 20.09.2026.
//

import Foundation

@Observable
final class ProductsViewModel {
    
    private(set) var products: [Product] = []
    private(set) var isLoading = false
    private(set) var isLoadingMore = false
    private(set) var isFinished = false
    private(set) var error: AppError?
    private(set) var retryCount = 0
    private(set) var totalCount: Int?
    
    let category: String?
    var shouldShowLoading: Bool { products.isEmpty && isLoading }
    var shouldShowError: Bool { products.isEmpty && error != nil }
    
    private let pageSize = 10
    private var nextSkip = 0
    
    private let onSessionExpired: () -> Void
    private let productsUseCase: ProductsUseCaseProtocol
    
    init(category: String?,
         productsUseCase: ProductsUseCaseProtocol,
         onSessionExpired: @escaping () -> Void) {
        self.category = category
        self.productsUseCase = productsUseCase
        self.onSessionExpired = onSessionExpired
    }
    
    // MARK: - Pagination
    func loadFirstPage() async {
        guard !isLoading, !isLoadingMore else { return }
        
        isLoading = true
        error = nil
        isFinished = false
        defer { isLoading = false }
        
        do {
            let page = try await productsUseCase.getProducts(category: category, limit: pageSize, skip: 0)
            products = page.items
            totalCount = page.total
            nextSkip = page.nextSkip
            isFinished = !page.hasMore
        } catch is CancellationError {
            // No error
        } catch let error as AppError {
            if error.isSessionExpired {
                onSessionExpired()
                return
            }
            
            self.error = error
        } catch {
            self.error = .unknown
        }
    }
    
    func loadMoreIfNeeded(current: Product) async {
        guard current.id == products.last?.id else { return }
        await loadMore()
    }
    
    func loadMore() async {
        guard !isLoading, !isLoadingMore, !isFinished, error == nil else { return }
        
        isLoadingMore = true
        defer { isLoadingMore = false }
        
        do {
            let page = try await productsUseCase.getProducts(category: category, limit: pageSize, skip: nextSkip)
            products.append(contentsOf: page.items)
            nextSkip = page.nextSkip
            isFinished = !page.hasMore
        } catch is CancellationError {
            // No error
        } catch let error as AppError {
            if error.isSessionExpired {
                onSessionExpired()
                return
            }
            
            self.error = error
        } catch {
            self.error = .unknown
        }
    }

    func loadIfNeeded() async {
        guard products.isEmpty else { return }
        await loadFirstPage()
    }

    func retry() {
        retryCount += 1
    }

    func clearError() {
        error = nil
    }
}
