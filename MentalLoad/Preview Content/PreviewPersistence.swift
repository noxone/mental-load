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
        
        result.createPreviewData()
        
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
    
    private func createPreviewData() {
        let context = container.viewContext
        
        let workArea = createArea(title: "Work", subtitle: "Work related tasks", context: context)
        let houseArea = createArea(title: "Househole", subtitle: nil, context: context)
        let childArea = createArea(title: "Child", subtitle: "Child related tasks", context: context)

        let task1 = createTask(withTitle: "Buy groceries", andSubtitle: "Some more description for groceries", for: workArea, context: context)
        let task2 = createTask(withTitle: "Clean house", andSubtitle: nil, for: workArea, context: context)
        let task3 = createTask(withTitle: "Do homework", andSubtitle: "Even more description for homework", for: workArea, context: context)
        
        let task4 = createTask(withTitle: "Feed Baby", andSubtitle: "", for: childArea, context: context)
        let task5 = createTask(withTitle: "Climb a mountain", andSubtitle: nil, for: houseArea, context: context)
        let task6 = createTask(withTitle: "Think of Kindergarden", andSubtitle: "What do you think of Kindergarden", for: houseArea, context: context)
        let task7 = createTask(withTitle: "List the alphabet", andSubtitle: "The alphabet consists of 26 letters and we need to list them for our baby and some quite strange other reasons", for: houseArea, context: context)
        let task8 = createTask(withTitle: "Do some coding", andSubtitle: "Well, we need to do some coding", for: houseArea, context: context)
        let task9 = createTask(withTitle: "Cook meals", andSubtitle: "Cooking meals is quite easy and one of the most important things", for: houseArea, context: context)
        let task10 = createTask(withTitle: "Think of meals", andSubtitle: "But before that we need to think of meals", for: houseArea, context: context)
        let task11 = createTask(withTitle: "Be yourself", andSubtitle: "And in the end we all need to be ourselves", for: houseArea, context: context)
        
        let part1 = createParticipant(withName: "Oscar", for: workArea, context: context)
        let part2 = createParticipant(withName: "Maria", for: workArea, context: context)
        
        let part3 = createParticipant(withName: "Juan", for: houseArea, context: context)
        
        let part4 = createParticipant(withName: "Benny", for: childArea, context: context)
        let part5 = createParticipant(withName: "Helena", for: childArea, context: context)
        let part6 = createParticipant(withName: "Eric", for: childArea, context: context)
        
        assign(task1, to: part1, context: context)
        assign(task2, to: part1, context: context)
        assign(task2, to: part2, context: context)
        assign(task3, to: part2, context: context)
        
        workArea.sort = 1
        houseArea.sort = 2
        childArea.sort = 3
        
        task1.sort = 1
        task2.sort = 2
        task3.sort = 3
        task4.sort = 4
        task5.sort = 5
        task6.sort = 6
        task7.sort = 7
        task8.sort = 8
        task9.sort = 9
        task10.sort = 10
        task11.sort = 11
        
        try! context.save()
    }
        
    @MainActor
    func preview_getWorkArea() -> MLArea {
        let context = PersistenceController.preview.container.viewContext
        let request = MLArea.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(MLArea.title), "Work")
        request.fetchLimit = 1
        
        return try! context.fetch(request).first!
    }
    
    @MainActor
    func preview_getChildArea() -> MLArea {
        let context = PersistenceController.preview.container.viewContext
        let request = MLArea.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(MLArea.title), "Child")
        request.fetchLimit = 1
        
        return try! context.fetch(request).first!
    }
    
    @MainActor
    func preview_getCleanHouseTask() -> MLTask {
        let context = PersistenceController.preview.container.viewContext
        let request = MLTask.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(MLTask.title), "Clean house")
        request.fetchLimit = 1
        
        return try! context.fetch(request).first!
    }
}
