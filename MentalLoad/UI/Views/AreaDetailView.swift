//
//  AreaDetailView.swift
//  MentalLoad
//
//  Created by Olaf Neumann on 31.12.24.
//

import SwiftUI

struct AreaDetailView: View {
    let area: MLArea
    
    /*@FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \MLTask.creationDate, ascending: true)],
        predicate: NSPredicate(format: "%K = %@", #keyPath(MentalLoad.MLTask.belongs_to), area),
        animation: .default)
    private var tasks: FetchedResults<MLTask>*/
    
    private var taskFetchRequest : FetchRequest<MLTask>
    private var tasks: FetchedResults<MLTask> {
        taskFetchRequest.wrappedValue
    }
    
    private var participantFetchRequest : FetchRequest<MLParticipant>
    private var participants: FetchedResults<MLParticipant> {
        participantFetchRequest.wrappedValue
    }
    
    init(_ area: MLArea) {
        self.area = area
        self.taskFetchRequest = FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \MLTask.creationDate, ascending: true)],
            predicate: NSPredicate(format: "%K == %@", #keyPath(MLTask.belongs_to), area),
            animation: .default
        )
        self.participantFetchRequest = FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \MLParticipant.name, ascending: true)],
            predicate: NSPredicate(format: "%K CONTAINS %@", #keyPath(MLParticipant.takes_part_in), area),
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
                    Section("Tasks") {
                        ForEach(tasks) { task in
                            NavigationLink(value: task) {
                                OptionalValueDisplay(task.title, alternative: "No task title")
                            }
                        }
                    }
                    Section("Participants") {
                        ForEach(participants) { participant in
                            OptionalValueDisplay(participant.name, alternative: "No name")
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle(area.title ?? "No title")
    }
}

#Preview {
    NavigationStack {
        AreaDetailView(PersistenceController.preview.preview_getChildArea())
    }
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
