//
//  EmptyValueDisplay.swift
//  MentalLoad
//
//  Created by Olaf Neumann on 01.01.25.
//

import SwiftUI

struct OptionalValueDisplay<T, C: View>: View {
    
    let object: T?
    let alternative: LocalizedStringKey
    let content: (T) -> C
    
    init(_ object: T?, alternative: LocalizedStringKey? = nil) where T == String, C == Text {
        self.init(object, alternative: alternative, content: { Text($0) })
    }
    
    init(_ object: T?, alternative: LocalizedStringKey? = nil, @ViewBuilder content: @escaping (T) -> C) {
        self.object = object
        self.alternative = alternative ?? "No content"
        self.content = content
    }
    
    var body: some View {
        if let object {
            content(object)
        } else {
            Text(alternative)
                .italic()
                .opacity(0.7)
        }
    }
}

#Preview {
    OptionalValueDisplay("Bernd") { object in Text(object) }
}
