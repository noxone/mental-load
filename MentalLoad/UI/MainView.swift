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
        sortDescriptors: [NSSortDescriptor(keyPath: \Area.creationDate, ascending: true)],
        animation: .default)
    private var areas: FetchedResults<Area>
    
    var body: some View {
        NavigationStack {
            ZStack {
                FloatingClouds()
                AreaListView()
                    .navigationDestination(for: Area.self) { area in
                        AreaDetailView(area: area)
                    }
            }
        }
    }
}

#Preview {
    MainView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
