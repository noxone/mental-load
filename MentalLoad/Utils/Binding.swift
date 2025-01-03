//
//  Binding.swift
//  MentalLoad
//
//  Created by Olaf Neumann on 03.01.25.
//

import SwiftUI

public extension Binding {
    static func ?? <Wrapped>(optional: Self, defaultValue: Wrapped) -> Binding<Wrapped> where Value == Wrapped? {
        .init(
            get: { optional.wrappedValue ?? defaultValue },
            set: { optional.wrappedValue = $0 }
        )
    }
    
    func withDefault<Wrapped>(_ defaultValue: Wrapped, set: @escaping (Wrapped) -> Wrapped? ) -> Binding<Wrapped> where Value == Wrapped? {
        return Binding<Wrapped>(
            get: { self.wrappedValue ?? defaultValue },
            set: { self.wrappedValue = set($0) })
    }
}
