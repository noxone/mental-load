//
//  String.swift
//  MentalLoad
//
//  Created by Olaf Neumann on 01.01.25.
//

extension String {
    func emptyToNull() -> String? {
        if self.isEmpty {
            return nil
        }
        return self
    }
}
