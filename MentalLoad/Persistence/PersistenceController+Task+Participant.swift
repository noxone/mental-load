//
//  PersistenceController+Area+Task.swift
//  MentalLoad
//
//  Created by Olaf Neumann on 01.01.25.
//

import CoreData

extension PersistenceController {
    func assign(_ task: MLTask, to participant: MLParticipant, context: NSManagedObjectContext) {
        task.addToIs_assigned_to(participant)
        context.save(with: .updateTaskParticipantRelationship)
    }
}
