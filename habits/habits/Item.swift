//
//  Item.swift
//  habits
//
//  Created by Lehi Alcantara on 12/21/23.
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
