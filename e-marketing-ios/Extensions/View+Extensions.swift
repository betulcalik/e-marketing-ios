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
        router: AppRouter,
        client: HTTPClientProtocol
    ) -> some View {
        navigationDestination(for: AppRoute.self) { route in
            AppDestinationView(
                route: route,
                appSession: appSession,
                router: router,
                client: client
            )
        }
    }
    
    func errorAlert(error: AppError?, onDismiss: (() -> Void)? = nil) -> some View {
        modifier(ErrorAlert(error: error, onDismiss: onDismiss))
    }
}
