//
//  AppRoute.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 19.09.2026.
//

import Foundation

/// App-wide navigation route
enum AppRoute: Hashable {
    case categories
    case products(category: String?)
}
