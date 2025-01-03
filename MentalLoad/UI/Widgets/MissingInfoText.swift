//
//  MissingInfoText.swift
//  MentalLoad
//
//  Created by Olaf Neumann on 03.01.25.
//

import SwiftUI

struct MissingInfoText: View {
    let text: LocalizedStringKey
    
    init(_ text: LocalizedStringKey) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .italic()
            .opacity(0.7)
    }
}

#Preview {
    MissingInfoText("Moin!")
}
