//
//  EditableTitledText.swift
//  MentalLoad
//
//  Created by Olaf Neumann on 01.01.25.
//

import SwiftUI

struct EditableTitledText: View {
    @Environment(\.editMode) private var editMode
    
    let titleKey: LocalizedStringKey
    let text: Binding<String?>
    var noContentText: LocalizedStringKey = "No content"
    
    private var isEditing: Bool {
        editMode?.wrappedValue.isEditing ?? false
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Title(titleKey)
                .font(.caption.smallCaps())
                .foregroundColor(Color.secondary)
            
            if !isEditing {
                OptionalValueDisplay(text.wrappedValue, alternative: noContentText)
            } else {
                TextField(titleKey, text: Binding(get: {text.wrappedValue ?? ""}, set: {text.wrappedValue = $0.emptyToNull()}))
            }
        }
    }
}

#Preview {
    EditableTitledText(titleKey: "Description", text: .constant("Berg"))
    
    EditableTitledText(titleKey: "Description", text: .constant(nil))
}
