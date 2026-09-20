//
//  CategoriesViewModel+Preview.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 20.09.2026.
//

import Foundation

#if DEBUG
extension CategoriesViewModel {
    static var preview: CategoriesViewModel {
        CategoriesViewModel(homeUseCase: MockHomeUseCase())
    }
}
#endif
