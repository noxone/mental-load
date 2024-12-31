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
        sortDescriptors: [NSSortDescriptor(keyPath: \Area.creationDate, ascending: true)],
        animation: .default)
    private var areas: FetchedResults<Area>
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 25, pinnedViews: [.sectionHeaders]) {
                Section(header: Text("Areas").font(.largeTitle).bold().background(.ultraThinMaterial, in: Rectangle())) {
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
