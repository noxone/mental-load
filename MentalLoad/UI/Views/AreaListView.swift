//
//  AreaList.swift
//  MentalLoad
//
//  Created by Olaf Neumann on 30.12.24.
//

import SwiftUI

struct AreaListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \MLArea.creationDate, ascending: true)],
        animation: .default)
    private var areas: FetchedResults<MLArea>
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 25, pinnedViews: [.sectionHeaders]) {
                Section {
                    ForEach(areas) { area in
                        NavigationLink(value: area) {
                            AreaDisplay(area: area)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AreaListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
