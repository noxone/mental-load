//
//  AreaDisplay.swift
//  MentalLoad
//
//  Created by Olaf Neumann on 30.12.24.
//

import SwiftUI

struct AreaDisplay: View {
    let area: MLArea
    
    var body: some View {
        ZStack {
            /*FloatingClouds()
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: .black.opacity(0.4), radius: 8)*/
            RoundedRectangle(cornerRadius: 20)
                .fill(.thickMaterial)
                .shadow(color: .black.opacity(0.4), radius: 10)
            VStack(alignment: .leading) {
                Text(area.title ?? "No title")
                    .font(.title)
                HyphenableText(area.subtitle ?? "")
                    .font(.callout)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
        }
        .frame(width: 300, height: 150)
    }
}

#Preview {
    @Previewable let area = {
        let context = PersistenceController.preview.container.viewContext
        let area = MLArea(context: context)
        area.title = "Title"
        area.subtitle = "Some more text for the subtitle mentioning where we can think about other stuff to do like syllable breaks. Now we add even more text to this so it may overflow the area and we can see how it looks."
        return area
    }()
    
    AreaDisplay(area: area)
}
