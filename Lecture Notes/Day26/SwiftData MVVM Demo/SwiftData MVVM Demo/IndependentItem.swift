//
//  IndependentItem.swift
//  SwiftData MVVM Demo
//
//  Created by Stephen Liddle on 12/6/23.
//

import Foundation
import SwiftData

@Model
final class IndependentItem {
    var title: String

    // This creates a many-to-many relationship with Item because Item's
    // indepdendentItems references IndependentItem, and the items property
    // here references Item.  With a many-to-many relationship, it's likely
    // that the right way to handle deletion is the deleteRule .nullify, which
    // is the default, so I haven't specified it here.
    @Relationship(inverse: \Item.independentItems)
    var items: [Item] = []

    init(title: String, items: [Item] = []) {
        self.title = title
        self.items = items
    }
}
