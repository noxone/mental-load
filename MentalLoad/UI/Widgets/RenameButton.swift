//
//  RenameButton.swift
//  MentalLoad
//
//  Created by Olaf Neumann on 02.01.25.
//

import SwiftUI

struct RenameButton: View {
    let buttonLabel: LocalizedStringKey
    let textHint: LocalizedStringKey
    let message: LocalizedStringKey?
    let systemImage: String
    
    @Binding var value: String
    
    @State private var newValue: String = ""
    @State private var showRenameAlert = false
    
    init(buttonLabel: LocalizedStringKey = "Rename", systemImage: String = "square.and.pencil", textHint: LocalizedStringKey = "New value", message: LocalizedStringKey? = nil, value: Binding<String?>) {
        self.init(buttonLabel: buttonLabel,
                  systemImage: systemImage,
                  textHint: textHint,
                  message: message,
                  value: value.withDefault("") { $0.emptyToNull() })
    }
    
    init(buttonLabel: LocalizedStringKey = "Rename", systemImage: String = "square.and.pencil", textHint: LocalizedStringKey = "New value", message: LocalizedStringKey? = nil, value: Binding<String>) {
        self.buttonLabel = buttonLabel
        self.textHint = textHint
        self.message = message
        self.systemImage = systemImage
        self._value = value
    }
    
    var body: some View {
        Button(action: {
            newValue = value
            showRenameAlert = true
        },
               label: { Label(buttonLabel, systemImage: systemImage) })
        .alert(
            Text(buttonLabel),
            isPresented: $showRenameAlert
        ) {
            Button("Cancel", role: .cancel) {
                newValue = ""
            }
            Button("OK") {
                value = newValue
                newValue = ""
            }
            
            TextField(textHint, text: $newValue)
                .textContentType(.jobTitle)
        } message: {
            if let message {
                Text(message)
            } else {
                EmptyView()
            }
        }
    }
}

#Preview {
    RenameButton(buttonLabel: "Rename it!", textHint: "New value here...", value: .constant("value"))
}
