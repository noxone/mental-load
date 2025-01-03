//
//  TaskDetailView.swift
//  MentalLoad
//
//  Created by Olaf Neumann on 01.01.25.
//

import SwiftUI

struct TaskDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.editMode) private var editMode

    @State private var showAddParticipantSheet: Bool = false
    @State private var showRenameTaskAlert = false
    @State private var newTaskName: String = ""

    @ObservedObject var task: MLTask
    
    private var fetchRequestForTask : FetchRequest<MLParticipant>
    private var participantsOfTask: FetchedResults<MLParticipant> {
        fetchRequestForTask.wrappedValue
    }
    
    private var fetchRequestForArea : FetchRequest<MLParticipant>
    private var participantsOfArea: FetchedResults<MLParticipant> {
        fetchRequestForArea.wrappedValue
    }
    
    init(_ task: MLTask) {
        self.task = task
        self.fetchRequestForTask = FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \MLParticipant.name, ascending: true)],
            predicate: NSPredicate(format: "%K CONTAINS %@", #keyPath(MLParticipant.has_assigned), task),
            animation: .default
        )
        self.fetchRequestForArea = FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \MLParticipant.name, ascending: true)],
            predicate: NSPredicate(format: "%K CONTAINS %@", #keyPath(MLParticipant.takes_part_in), task.belongs_to!),
            animation: .default
        )
    }

    var body: some View {
        List {
            Section("Task Description") {
                EditableText(titleKey: "Description", text: $task.subtitle, noContentText: "No description given")
            }
            Section("Assigned Participants") {
                if editMode.isEditing || !participantsOfTask.isEmpty {
                    ForEach(participantsOfTask) { participant in
                        OptionalValueDisplay(participant.name, alternative: "No name")
                    }
                    .onDelete(perform: removeParticipantsFromTask)
                    if editMode.isEditing {
                        let filteredParticipants = participantsOfArea.filter { !participantsOfTask.contains($0) }
                        if !filteredParticipants.isEmpty {
                            Button(action: { showAddParticipantSheet = true }, label: {Text("Add participant")})
                                .confirmationDialog("Add participant", isPresented: $showAddParticipantSheet, titleVisibility: .automatic) {
                                    ForEach(filteredParticipants) { participant in
                                        Button(action: {
                                            showAddParticipantSheet = false
                                            addParticipantToTask(participant)
                                        }, label: { OptionalValueDisplay(participant.name) })
                                    }
                                }
                        }
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
            ToolbarItem(placement: .primaryAction) {
                EditButton()
            }
            if editMode.isEditing {
                ToolbarItem(placement: .cancellationAction) {
                    RenameButton(buttonLabel: "Rename task", textHint: "New task name", value: $task.title)
                    .onChange(of: task.title ?? "") { _, newValue in
                        rename(task, to: newValue)
                    }
                }
            }
        }
    }
    
    private func addParticipantToTask(_ participant: MLParticipant) {
        withAnimation {
            PersistenceController.shared.assign(task, to: participant, context: viewContext)
        }
    }
    
    private func removeParticipantsFromTask(offsets: IndexSet) {
        withAnimation {
            offsets.map { participantsOfTask[$0] }
                .forEach { PersistenceController.shared.unassign(task, from: $0, context: viewContext) }
        }
    }
    
    private func rename(_ task: MLTask, to newName: String) {
        withAnimation {
            task.title = newName
            viewContext.save(with: .updateTask)
        }
    }
}

#Preview {
    NavigationStack {
        TaskDetailView(PersistenceController.preview.preview_getCleanHouseTask())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
