//
//  Recipe.swift
//  modelsRelated
//
//  Created by Lehi Alcantara on 12/17/23.
//

import Foundation
import SwiftData

@Model
final class Recipe {
    var title: String
    var author: String
    // @Relationship(deleteRule: .nullify) // This is the default, so it's not necessary to list it.
    var category = [Category]()
    
    init(title: String, author: String, category: [Category]) {
        self.title = title
        self.author = author
        self.category = category
    }
}

@Model
final class Category {
    @Attribute(.unique) var name: String
    
    // This creates a many-to-many relationship with Recipe because Recipe's
    // category references Category, and the recipes property
    // here references Recipe.  With a many-to-many relationship, it's likely
    // that the right way to handle deletion is the deleteRule .nullify, which
    // is the default, so I haven't specified it here.
    @Relationship(inverse: \Recipe.category)
    var recipes = [Recipe]()
    
    init(name: String) {
        self.name = name
    }
}
