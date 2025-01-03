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
    
    var body: some View {
        if !editMode.isEditing {
            OptionalValueDisplay(text.wrappedValue, alternative: noContentText)
        } else {
            TextEditor(text: text ?? "")
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
