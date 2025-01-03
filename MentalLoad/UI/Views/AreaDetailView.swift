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
                        .onDelete(perform: removeTasks)
                    } else {
                        MissingInfoText("No tasks added yet")
                    }
                }
                Section("Participants") {
                    if !participants.isEmpty {
                        ForEach(participants) { participant in
                            let deleteAllowed = participant.has_assigned?.count ?? 0 > 0
                            HStack {
                                OptionalValueDisplay(participant.name, alternative: "No name")
                                Spacer()
                                if deleteAllowed, let numberOfAssignedTasks = participant.has_assigned?.count {
                                    Text("\(numberOfAssignedTasks)")
                                        .opacity(0.7)
                                }
                            }
                            .deleteDisabled(deleteAllowed)
                        }
                        .onDelete(perform: removeParticipant)
                    } else {
                        MissingInfoText("No participants configured yet.")
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle(area.title ?? "No title")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                EditButton()
            }
            
            if editMode.isEditing {
                ToolbarItem(placement: .cancellationAction) {
                    RenameButton(buttonLabel: "Rename area", textHint: "New area name", value: $area.title)
                        .onChange(of: area.title) { _, _ in
                            areaDidRename()
                    }
                }
            }
        }
    }
    
    private func areaDidRename() {
        viewContext.save(with: .updateArea)
    }
    
    private func removeTasks(_ offsets: IndexSet) {
        withAnimation {
            offsets.map { tasks[$0] }
                .forEach { PersistenceController.shared.remove(task: $0, from: area, context: viewContext) }
        }
    }
    
    private func removeParticipant(_ offsets: IndexSet) {
        withAnimation {
            offsets.map { participants[$0] }
                .forEach { PersistenceController.shared.remove(participant: $0, from: area, context: viewContext) }
        }
    }
}

#Preview {
    NavigationStack {
        AreaDetailView(PersistenceController.preview.preview_getChildArea())
    }
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
