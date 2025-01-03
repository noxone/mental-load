//
//  MainView.swift
//  MentalLoad
//
//  Created by Olaf Neumann on 31.12.24.
//

import SwiftUI

struct MainView: View {
    @State private var navigationPath = NavigationPath()
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \MLArea.creationDate, ascending: true)],
        animation: .default)
    private var areas: FetchedResults<MLArea>
    
    var body: some View {
        NavigationStack {
            AreaListView()
                .navigationTitle("Areas")
                .toolbarTitleDisplayMode(.inlineLarge)
                .navigationDestination(for: MLArea.self) { area in
                    AreaDetailView(area)
                }
                .navigationDestination(for: MLTask.self) { task in
                    TaskDetailView(task)
                }
        }
    }
}

#Preview {
    MainView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
