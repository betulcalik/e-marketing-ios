//
//  HomeViewModel+Preview.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 20.09.2026.
//

import Foundation

#if DEBUG
extension HomeViewModel {
    static var preview: HomeViewModel {
        HomeViewModel(homeUseCase: MockHomeUseCase())
    }
}
#endif
