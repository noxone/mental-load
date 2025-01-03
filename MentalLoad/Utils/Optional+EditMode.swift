//
//  EditMode.swift
//  MentalLoad
//
//  Created by Olaf Neumann on 02.01.25.
//

import SwiftUI

extension Optional where Wrapped == Binding<EditMode> {
    var isEditing: Bool {
        return self?.wrappedValue.isEditing ?? false
    }
}
