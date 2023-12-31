//
//  AnimalEditor.swift
//  addEditSwiftData
//
//  Created by Lehi Alcantara on 12/19/23.
//

import SwiftUI
import SwiftData

struct AnimalEditor: View {
    let animal: Animal?
    
    private var editorTitle: String {
        animal == nil ? "Add Animal" : "Edit Animal"
    }
    
    @State private var name = ""
    @State private var selectedDiet = Animal.Diet.herbivorous
    @State private var selectedCategory: AnimalCategory?
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \AnimalCategory.name) private var categories: [AnimalCategory]
    

    
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                
                Picker("Category", selection: $selectedCategory) {
                    Text("Select a category").tag(nil as AnimalCategory?)
                    ForEach(categories) { category in
                        Text(category.name).tag(category as AnimalCategory?)
                    }
                }
                
                Picker("Diet", selection: $selectedDiet) {
                    ForEach(Animal.Diet.allCases, id: \.self) { diet in
                        Text(diet.rawValue).tag(diet)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(editorTitle)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        withAnimation {
                            save()
                            dismiss()
                        }
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            if let animal {
                // Edit the incoming animal.
                name = animal.name
                selectedDiet = animal.diet
                selectedCategory = animal.category
            }
        }
    }
    
    private func save() {
        if let animal {
            // Edit the animal.
            animal.name = name
            animal.diet = selectedDiet
            animal.category = selectedCategory
        } else {
            // Add an animal.
            let newAnimal = Animal(name: name, diet: selectedDiet)
            newAnimal.category = selectedCategory
            modelContext.insert(newAnimal)
        }
    }
}

#Preview("Add animal") {
        AnimalEditor(animal: nil)
}

#Preview("Edit animal") {
    AnimalEditor(animal: .kangaroo)
}
