//
//  Logger.swift
//  MentalLoad
//
//  Created by Olaf Neumann on 31.12.24.
//

import os

extension Logger {
    public init(category: String) {
        self.init(subsystem: "MentalLoad", category: category)
    }
}
