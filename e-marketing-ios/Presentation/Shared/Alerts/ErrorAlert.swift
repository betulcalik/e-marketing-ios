//
//  ErrorAlert.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 19.09.2026.
//

import SwiftUI

struct ErrorAlert: ViewModifier {

    let message: String?
    var onDismiss: (() -> Void)? = nil

    func body(content: Content) -> some View {
        content.alert(
            "error.alert.title",
            isPresented: Binding(
                get: { message != nil },
                set: { presented in
                    if !presented { onDismiss?() }
                }
            ),
            actions: {
                Button("common.ok", role: .cancel) { }
            },
            message: {
                Text(message ?? "")
            }
        )
    }
}
