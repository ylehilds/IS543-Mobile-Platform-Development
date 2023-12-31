//
//  newRecipeView.swift
//  Recipes
//
//  Created by Lehi Alcantara on 11/27/23.
//

import SwiftUI
import SwiftData

struct NewRecipeView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: [SortDescriptor(\Recipe.title)]) private var recipes: [Recipe]
    
    @Query(sort: [SortDescriptor(\Category.name)]) private var categories: [Category]
    var uniqueCategories: [Category] {
        var uniqueNames = Set<String>()
        return categories.filter { uniqueNames.insert($0.name).inserted }
    }
    
    @State private var showAlert = false
    @State private var selectedCategories: [Category] = []
    
    @State private var title = ""
    @State private var author = ""
    @State private var date = ""
    @State private var timeRequired = ""
    @State private var servings = ""
    @State private var expertiseRequired = ""
    @State private var caloriesPerServing = ""
    @State private var ingredients = ""
    @State private var instructions = ""
    @State private var notes = ""
    
    var body: some View {
        VStack {
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                Spacer()
                
                Text("New Recipe").font(.headline)
                Spacer()
                
                Button("Save") {
                    if title.isEmpty || author.isEmpty || date.isEmpty || timeRequired.isEmpty || servings.isEmpty || expertiseRequired.isEmpty || caloriesPerServing.isEmpty || ingredients.isEmpty || instructions.isEmpty {
                        showAlert = true
                    } else {
                        addItem()
                        dismiss()
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text("All text fields are required"), dismissButton: .default(Text("OK")))
                }
            }
            .padding()
            Form {
                TextField("Title", text: $title, axis: .vertical)
                TextField("Author", text: $author, axis: .vertical)
                TextField("Date", text: $date, axis: .vertical)
                TextField("Time Required", text: $timeRequired, axis: .vertical)
                TextField("Servings", text: $servings, axis: .vertical)
                TextField("Expertise Required", text: $expertiseRequired, axis: .vertical)
                TextField("Calories Per Serving", text: $caloriesPerServing, axis: .vertical)
                TextField("Ingredients", text: $ingredients, axis: .vertical)
                TextField("Instructions", text: $instructions, axis: .vertical)
                TextField("Notes", text: $notes, axis: .vertical)
                // When the picker only accepted 1 value
                //                Picker("Category", selection: $category) {
                //                    Text("").tag("")
                //                    ForEach(categories) { category in
                //                        Text(category.name).tag(category.name)
                //                    }
                //                }
                Section(header: Text("Categories")) {
                    List {
                        ForEach(uniqueCategories) { category in
                            Toggle(category.name, isOn: Binding(
                                get: { self.selectedCategories.contains(where: { $0.name == category.name }) },
                                set: { (newValue) in
                                    if newValue {
                                        self.selectedCategories.append(category)
                                    } else {
                                        self.selectedCategories.removeAll { $0 == category }
                                    }
                                }
                            ))
                        }
                        
                    }
                    //                Text("Selected Categories: \(selectedCategories.map { $0.name }.joined(separator: ", ") )")
                }
            }
        }
    }
    
    private func addItem() {
        withAnimation {
            let recipe = Recipe(title: title, author: author, date: date, timeRequired: timeRequired, servings: servings, expertiseRequired: expertiseRequired, caloriesPerServing: caloriesPerServing, ingredients: ingredients, instructions: instructions, notes: notes, category: [], favorite: false)
            
            // Add selected categories
            for category in selectedCategories {
                recipe.category.append(category)
            }
            modelContext.insert(recipe)
        }
    }
}

#Preview {
    NewRecipeView()
}
