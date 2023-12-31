//
//  Recipe.swift
//  Recipes
//
//  Created by Lehi Alcantara on 11/21/23.
//

import Foundation
import SwiftData

@Model
final class Recipe {
    var title: String
    var author: String
    var date: String
    var timeRequired: String
    var servings: String
    var expertiseRequired: String
    var caloriesPerServing: String
    var ingredients: String
    var instructions: String
    var notes: String
    // @Relationship(deleteRule: .nullify) // This is the default, so it's not necessary to list it.
    var category: [Category]
    var favorite: Bool
    
    init(title: String, author: String, date: String, timeRequired: String, servings: String, expertiseRequired: String, caloriesPerServing: String, ingredients: String, instructions: String, notes: String, category: [Category], favorite: Bool) {
        self.title = title
        self.author = author
        self.date = date
        self.timeRequired = timeRequired
        self.servings = servings
        self.expertiseRequired = expertiseRequired
        self.caloriesPerServing = caloriesPerServing
        self.ingredients = ingredients
        self.instructions = instructions
        self.notes = notes
        self.category = category
        self.favorite = favorite
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
