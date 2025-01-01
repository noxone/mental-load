//
//  TaskDetailView.swift
//  MentalLoad
//
//  Created by Olaf Neumann on 01.01.25.
//

import SwiftUI

struct TaskDetailView: View {
    @Environment(\.editMode) private var editMode
    
    @State var task: MLTask
    
    private var fetchRequest : FetchRequest<MLParticipant>
    private var participants: FetchedResults<MLParticipant> {
        fetchRequest.wrappedValue
    }
    
    init(_ task: MLTask) {
        self.task = task
        self.fetchRequest = FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \MLParticipant.name, ascending: true)],
            predicate: NSPredicate(format: "%K CONTAINS %@", #keyPath(MLParticipant.has_assigned), task),
            animation: .default
        )
    }

    var body: some View {
        List {
            Section("Description") {
                OptionalValueDisplay(task.subtitle, alternative: "No description")
            }
            Section("Participants") {
                if !participants.isEmpty {
                    ForEach(participants) { participant in
                        OptionalValueDisplay(participant.name, alternative: "No name")
                    }
                } else {
                    Text("No participants yet")
                        .italic()
                }
            }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .navigationTitle(task.title ?? "No task title")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .automatic) {
                EditButton()
            }
        }
    }
}

#Preview {
    NavigationStack {
        TaskDetailView(PersistenceController.preview.preview_getCleanHouseTask())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
