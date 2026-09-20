//
//  AppRouter.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 20.09.2026.
//

import Observation

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
