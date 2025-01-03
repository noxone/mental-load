//
//  PersistenceController+Area+Task.swift
//  MentalLoad
//
//  Created by Olaf Neumann on 01.01.25.
//

import CoreData

extension PersistenceController {
    func createTask(withTitle title: String, andSubtitle subtitle: String?, for area: MLArea, context: NSManagedObjectContext) -> MLTask {
        let task = MLTask(context: context)
        task.creationDate = Date()
        task.title = title
        task.subtitle = subtitle
        area.addToConsists_of(task)
        context.save(with: .addTask)
        return task
    }
    
    func remove(task: MLTask, from area: MLArea, context: NSManagedObjectContext) {
        area.removeFromConsists_of(task)
        context.delete(task)
        context.save(with: .deleteTask)
    }
}
