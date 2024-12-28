//
//  MentalLoadApp.swift
//  MentalLoad
//
//  Created by Olaf Neumann on 28.12.24.
//

import SwiftUI

@main
struct MentalLoadApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
