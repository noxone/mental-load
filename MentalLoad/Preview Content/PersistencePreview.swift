//
//  Persistence.swift
//  MentalLoad
//
//  Created by Olaf Neumann on 30.12.24.
//

import Foundation
import CoreData

extension PersistenceController {
    
    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        
        createPreviewData(in: viewContext)
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    private static func createPreviewData(in context: NSManagedObjectContext) {
        // create areas
        let areas = [
            Area(context: context),
            Area(context: context),
            Area(context: context),
        ]
        areas[0].title = "Work"
        areas[0].subtitle = "Work related tasks"
        areas[1].title = "Household"
        areas[2].title = "Child"
        areas[2].subtitle = "Child related tasks"
        for area in areas {
            area.creationDate = Date()
        }
        
        // create participants
        let participants = [
            Participant(context: context),
            Participant(context: context),
            Participant(context: context),
        ]
        participants[0].name = "Oscar"
        participants[1].name = "Maria"
        participants[2].name = "Juan"
        for participant in participants {
            participant.creationDate = Date()
        }
        
        // create tasks
        let taskNames: [String] = ["Buy groceries", "Clean house", "Do homework", "Feed Baby", "Climb a mountain", "Think of Kindergarden", "List the alphabet", "Do some coding", "Cook meals", "Think of meals", "Be yourself"]
        let tasks = taskNames.map { taskName in
            let task = Task(context: context)
            task.title = taskName
            task.creationDate = Date()
            task.icon = "pencil.tip.crop.circle.badge.plus.fill"
            if taskName.count % 3 != 0 {
                task.subtitle = "Some more description for \(taskName)"
            }
            return task
        }
        
        
        // connect some entities
        var area = areas[0]
        area.addToHas_participants(participants[0])
        area.addToHas_participants(participants[1])
        for index in 0..<8 {
            area.addToConsists_of(tasks[index])
        }
        for index in 0..<area.consists_of!.count {
            let task = area.consists_of!.allObjects[index] as! Task
            if index % 2 == 0 {
                task.addToIs_assigned_to(participants[0])
            }
            if index % 3 != 0 {
                task.addToIs_assigned_to(participants[1])
            }
        }
        
        
        areas[1].addToHas_participants(participants[1])
        areas[1].addToHas_participants(participants[2])

        areas[2].addToHas_participants(participants[0])
        areas[2].addToHas_participants(participants[1])
        areas[2].addToHas_participants(participants[2])
        for index in 3..<tasks.count {
            areas[2].addToConsists_of(tasks[index])
        }
    }
}
