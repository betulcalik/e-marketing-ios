//
//  AppRoute.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 19.09.2026.
//

import Foundation
import Observation

/// App-wide navigation route
enum AppRoute: Hashable {
    case categories
    case products(category: String?)
}

@Observable
final class AppRouter {
    var path: [AppRoute] = []

    // MARK: - Actions
    func push(_ route: AppRoute) {
        path.append(route)
    }

    func pop() {
        _ = path.popLast()
    }

    func popToRoot() {
        path.removeAll()
    }

    func reset() {
        path = []
    }
}
