//
//  Catalog.swift
//  addEditSwiftData
//
//  Created by Lehi Alcantara on 12/19/23.
//

import SwiftData


@Model
final class Animal {
    var name: String
    var diet: Diet
    var category: AnimalCategory?
    
    init(name: String, diet: Diet) {
        self.name = name
        self.diet = diet
    }
}

@Model
final class AnimalCategory {
    @Attribute(.unique) var name: String
    // `.cascade` tells SwiftData to delete all animals contained in the
    // category when deleting it.
    @Relationship(deleteRule: .cascade, inverse: \Animal.category)
    var animals = [Animal]()
    
    init(name: String) {
        self.name = name
    }
}

extension Animal {
    enum Diet: String, CaseIterable, Codable {
        case herbivorous = "Herbivore"
        case carnivorous = "Carnivore"
        case omnivorous = "Omnivore"
    }
}
