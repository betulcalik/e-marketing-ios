//
//  RequestInterceptor.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 21.09.2026.
//

import Foundation

// Middleware executed before the request is sent
protocol RequestInterceptor {
    func intercept(_ request: inout URLRequest)
}
