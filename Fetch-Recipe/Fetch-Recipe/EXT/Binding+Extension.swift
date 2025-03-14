//
//  Binding+Extension.swift
//  Fetch-Recipe
//
//  Created by Abhishek Dogra on 14/03/25.
//

import SwiftUI

extension Binding where Value == Bool {
    init<T: Equatable & Sendable>(_ value: Binding<T>, is equalTo: T) {
        self.init(
            get: { value.wrappedValue == equalTo },
            set: { _ in }
        )
    }
}
