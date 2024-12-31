//
//  AreaDetailView.swift
//  MentalLoad
//
//  Created by Olaf Neumann on 31.12.24.
//

import SwiftUI

struct AreaDetailView: View {
    let area: Area
    
    /*@FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.creationDate, ascending: true)],
        predicate: NSPredicate(format: "%K = %@", #keyPath(MentalLoad.Task.belongs_to), area),
        animation: .default)
    private var tasks: FetchedResults<Task>*/
    
    private var fetchRequest : FetchRequest<Task>
    private var tasks: FetchedResults<Task> {
        fetchRequest.wrappedValue
    }
    
    init(area: Area) {
        self.area = area
        self.fetchRequest = FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \Task.creationDate, ascending: true)],
            predicate: NSPredicate(format: "%K == %@", #keyPath(Task.belongs_to), area),
            animation: .default
        )
    }
    
    var body: some View {
        VStack {
            if tasks.isEmpty {
                VStack {
                    Text("No tasks added yet.")
                }
            } else {
                List {
                    ForEach(tasks) { task in
                        Text(task.title ?? "No task title")
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle(area.title ?? "No title")
    }
}

#Preview {
    @Previewable let area = {
        let context = PersistenceController.preview.container.viewContext
        let area = Area(context: context)
        area.title = "Area Title"
        area.subtitle = "Some more text for the subtitle mentioning where we can think about other stuff to do like syllable breaks. Now we add even more text to this so it may overflow the area and we can see how it looks."
        return area
    }()
    
    NavigationStack {
        AreaDetailView(area: area)
    }
}
