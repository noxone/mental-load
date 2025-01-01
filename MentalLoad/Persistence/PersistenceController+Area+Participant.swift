//
//  PersistenceController+Area+Task.swift
//  MentalLoad
//
//  Created by Olaf Neumann on 01.01.25.
//

import CoreData

extension PersistenceController {
    func createParticipant(withName name: String, for area: MLArea, context: NSManagedObjectContext) -> MLParticipant {
        let participant = MLParticipant(context: context)
        participant.creationDate = Date()
        participant.name = name

        area.addToHas_participants(participant)
        context.save(with: .addParticipant)
        return participant
    }
}
