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
    @State private var showAlert = false
    @State private var text: String = ""

    @State var task: MLTask
    
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
                if isEditing || !participantsOfTask.isEmpty {
                    ForEach(participantsOfTask) { participant in
                        OptionalValueDisplay(participant.name, alternative: "No name")
                    }
                    .onDelete(perform: removeParticipantsFromTask)
                    if isEditing {
                        Button(action: { showAddParticipantSheet = true }, label: {Text("Add participant")})
                            .confirmationDialog("Add participant", isPresented: $showAddParticipantSheet, titleVisibility: .automatic) {
                                ForEach(participantsOfArea.filter { !participantsOfTask.contains($0) }) { participant in
                                    Button(action: {
                                        addParticipantToTask(participant)
                                    }, label: { OptionalValueDisplay(participant.name) })
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
            if !isEditing {
                ToolbarItem(placement: .cancellationAction) {
                    renameTaskButton
                }
            }
        }
    }
    
    private var isEditing: Bool {
        editMode?.wrappedValue.isEditing ?? false
    }
    
    private var renameTaskButton: some View {
        Button(action: {
            text = task.title ?? ""
            showAlert = true
        },
               label: { Label("Rename task", systemImage: "square.and.pencil") })
        .alert(
            Text("Rename task"),
            isPresented: $showAlert
        ) {
            Button("Cancel", role: .cancel) {
                text = ""
            }
            Button("OK") {
                rename(task, to: text)
                text = ""
            }
            
            TextField("Task name", text: $text)
                .textContentType(.jobTitle)
        } message: {
            Text("Please enter you pin.")
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
