//
//  Item.swift
//  SwiftData MVVM Demo
//
//  Created by Stephen Liddle on 12/6/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var title: String

    @Relationship(deleteRule: .cascade)
    var dependentItems: [DependentItem] = []

    // @Relationship(deleteRule: .nullify) // This is the default, so it's not necessary to list it
    var independentItems: [IndependentItem] = []

    init(title: String, dependentItems: [DependentItem], independentItems: [IndependentItem]) {
        self.title = title
        self.dependentItems = dependentItems
        self.independentItems = independentItems
    }
}
