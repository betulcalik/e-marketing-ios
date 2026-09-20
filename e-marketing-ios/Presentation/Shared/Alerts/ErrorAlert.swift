//
//  ErrorAlert.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 19.09.2026.
//

import SwiftUI

struct ErrorAlert: ViewModifier {
    
    let error: AppError?
    let onDismiss: (() -> Void)?
    
    func body(content: Content) -> some View {
        content.alert(
            Text("error.alert.title"),
            isPresented: Binding(get: { error != nil },
                                 set: { if !$0 { onDismiss?() } }),
            presenting: error
        ) { _ in
            Button("common.ok", role: .cancel) { }
        } message: { error in
            Text(LocalizedStringKey(error.messageKey))
        }
    }
}
