//
//  EditableTitledText.swift
//  MentalLoad
//
//  Created by Olaf Neumann on 01.01.25.
//

import SwiftUI

struct EditableText: View {
    @Environment(\.editMode) private var editMode
    
    let titleKey: LocalizedStringKey
    let text: Binding<String?>
    var noContentText: LocalizedStringKey = "No content"
    
    private var isEditing: Bool {
        editMode?.wrappedValue.isEditing ?? false
    }
    
    var body: some View {
        if !isEditing {
            OptionalValueDisplay(text.wrappedValue, alternative: noContentText)
        } else {
            let binding = Binding(get: {text.wrappedValue ?? ""}, set: {text.wrappedValue = $0.emptyToNull()})
            TextEditor(text: binding)
                .frame(minHeight: 200)
        }
    }
}

#Preview {
    List {
        EditableText(titleKey: "Description", text: .constant("Berg"))
        
        EditableText(titleKey: "Description", text: .constant(nil))
        
        EditableText(titleKey: "Description", text: .constant("Hügel"))
            .environment(\.editMode, .constant(.active))
    }
}
