//
//  View+Bindings.swift
//  Map
//
//  Created by Nikola Malinovic on 25.03.21.
//

import SwiftUI

public extension View {
    /// Displays an alert bound to a system Error type.
    @ViewBuilder func alert(error: Binding<Error?>) -> some View {
        let hasError = Binding<Bool>(
            get: { error.wrappedValue != nil },
            set: { if !$0 { error.wrappedValue = nil }}
        )

        // Display an alert unless a banner should be displayed
        if let error = error.wrappedValue {
            let title = (error as? APIError)?.title ?? "Error"
            let message = (error as? APIError)?.detail ?? error.localizedDescription
            alert(isPresented: hasError) {
                Alert(title: Text(title), message: Text(message))
            }
        } else {
            self
        }
    }
}

public enum AlertError: Int, Error {
    case unauthorized = 401
}
