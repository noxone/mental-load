//
//  AreaDetailView.swift
//  MentalLoad
//
//  Created by Olaf Neumann on 31.12.24.
//

import SwiftUI

struct AreaDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.editMode) private var editMode
    
    @State private var showRenameTaskAlert = false
    @State private var newAreaName: String = ""
    
    @ObservedObject var area: MLArea
    
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
            List {
                Section("Tasks") {
                    if !tasks.isEmpty {
                        ForEach(tasks) { task in
                            NavigationLink(value: task) {
                                OptionalValueDisplay(task.title, alternative: "No task title")
                            }
                        }
                    } else {
                        MissingInfoText("No tasks added yet")
                    }
                }
                Section("Participants") {
                    if !participants.isEmpty {
                        ForEach(participants) { participant in
                            OptionalValueDisplay(participant.name, alternative: "No name")
                        }
                    } else {
                        MissingInfoText("No participants configured yet.")
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle(area.title ?? "No title")
        .toolbar {
            if editMode.isEditing {
                ToolbarItem(placement: .cancellationAction) {
                    RenameButton(buttonLabel: "Rename area", textHint: "New area name", value: $area.title)
                    .onChange(of: area.title) { _, newValue in
                        rename(area, to: newValue)
                    }
                }
            }
        }
    }
    
    private func rename(_ area: MLArea, to newName: String?) {
        withAnimation {
            area.title = newName
            viewContext.save(with: .updateArea)
        }
    }
}

#Preview {
    NavigationStack {
        AreaDetailView(PersistenceController.preview.preview_getChildArea())
    }
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
