//
//  Item.swift
//  addEditSwiftData
//
//  Created by Lehi Alcantara on 12/19/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
