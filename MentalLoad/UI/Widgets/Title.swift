//
//  Title.swift
//  MentalLoad
//
//  Created by Olaf Neumann on 01.01.25.
//

import SwiftUI

struct Title: View {
    private let titleKey: LocalizedStringKey
    
    public init(_ titleKey: LocalizedStringKey) {
        self.titleKey = titleKey
    }
    
    var body: some View {
        Text(titleKey)
            .font(.caption.smallCaps())
            .foregroundColor(Color.secondary)
    }
}

#Preview {
    Title("Some title")
}
