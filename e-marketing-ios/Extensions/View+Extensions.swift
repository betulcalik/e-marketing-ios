//
//  View+Extensions.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 19.09.2026.
//

import SwiftUI

extension View {
    func appDestinations(
        appSession: AppSessionStore,
        router: AppRouter
    ) -> some View {
        navigationDestination(for: AppRoute.self) { route in
            AppDestinationView(
                route: route,
                appSession: appSession,
                router: router
            )
        }
    }
    
    func errorAlert(message: String?, onDismiss: (() -> Void)? = nil) -> some View {
        modifier(ErrorAlert(message: message, onDismiss: onDismiss))
    }
}
