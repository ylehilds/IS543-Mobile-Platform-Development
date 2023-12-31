//
//  EditRecipeView.swift
//  Recipes
//
//  Created by Lehi Alcantara on 11/29/23.
//

import SwiftUI
import SwiftData

struct EditRecipeView: View {
    var recipe: Recipe?
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showAlert = false
    
    @Query private var categories: [Category]
    @State private var selectedCategories: [Category] = []
    
    init(recipe: Recipe?) {
        self.recipe = recipe
        _selectedCategories = State(initialValue: recipe?.category ?? [])
    }
    
    func formIsValid(_ recipe: Recipe) -> Bool {
        !recipe.title.isEmpty && !recipe.author.isEmpty && !recipe.date.isEmpty && !recipe.timeRequired.isEmpty && !recipe.servings.isEmpty && !recipe.expertiseRequired.isEmpty && !recipe.caloriesPerServing.isEmpty && !recipe.ingredients.isEmpty && !recipe.instructions.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if let recipe {
                    Form {
                        Section(header: Text("Title")) {
                            TextField("Title", text: Binding(get: { recipe.title }, set: { newValue in
                                recipe.title = newValue
                                if recipe.title.isEmpty {
                                    showAlert = true
                                }
                            }), axis: .vertical)
                        }
                        Section(header: Text("Author")) {
                            TextField("Author", text: Binding(get: { recipe.author }, set: { newValue in
                                recipe.author = newValue
                                if recipe.author.isEmpty {
                                    showAlert = true
                                }
                            }), axis: .vertical)
                        }
                        Section(header: Text("Date")) {
                            TextField("Date", text: Binding(get: { recipe.date }, set: { newValue in
                                recipe.date = newValue
                                if recipe.date.isEmpty {
                                    showAlert = true
                                }
                            }), axis: .vertical)
                        }
                        Section(header: Text("Time Required")) {
                            TextField("Time Required", text: Binding(get: { recipe.timeRequired }, set: { newValue in
                                recipe.timeRequired = newValue
                                if recipe.timeRequired.isEmpty {
                                    showAlert = true
                                }
                            }), axis: .vertical)
                        }
                        Section(header: Text("Servings")) {
                            TextField("Servings", text: Binding(get: { recipe.servings }, set: { newValue in
                                recipe.servings = newValue
                                if recipe.servings.isEmpty {
                                    showAlert = true
                                }
                            }), axis: .vertical)
                        }
                        Section(header: Text("Expertise Required")) {
                            TextField("Expertise Required", text: Binding(get: { recipe.expertiseRequired }, set: { newValue in
                                recipe.expertiseRequired = newValue
                                if recipe.expertiseRequired.isEmpty {
                                    showAlert = true
                                }
                            }), axis: .vertical)
                        }
                        Section(header: Text("Calories Per Serving")) {
                            TextField("Calories Per Serving", text: Binding(get: { recipe.caloriesPerServing }, set: { newValue in
                                recipe.caloriesPerServing = newValue
                                if recipe.caloriesPerServing.isEmpty {
                                    showAlert = true
                                }
                            }), axis: .vertical)
                        }
                        Section(header: Text("Ingredients")) {
                            TextField("Ingredients", text: Binding(get: { recipe.ingredients }, set: { newValue in
                                recipe.ingredients = newValue
                                if recipe.ingredients.isEmpty {
                                    showAlert = true
                                }
                            }), axis: .vertical)
                        }
                        Section(header: Text("Instructions")) {
                            TextField("Instructions", text: Binding(get: { recipe.instructions }, set: { newValue in
                                recipe.instructions = newValue
                                if recipe.instructions.isEmpty {
                                    showAlert = true
                                }
                            }), axis: .vertical)
                        }
                        Section(header: Text("notes")) {
                            TextField("Notes", text: Binding(get: { recipe.notes }, set: { recipe.notes = $0 }), axis: .vertical)
                        }
                        Section(header: Text("Categories")) {
                            // When the picker only accepted 1 value
                            
                            //                            Picker("Category", selection: Binding(get: { recipe.category }, set: { newValue in
                            //                                recipe.category = newValue
                            //                                if recipe.category.isEmpty {
                            //                                   showAlert = true
                            //                               }
                            //                            })) {
                            //                                ForEach(categories) { category in
                            //                                    Text(category.name).tag(category.name)
                            //                                }
                            //                            }
                            List {
                                ForEach(categories, id: \.self) { category in
                                    Toggle(category.name, isOn: Binding(
                                        get: { self.selectedCategories.contains(category) },
                                        set: { (newValue) in
                                            if newValue {
                                                self.selectedCategories.append(category)
                                            } else {
                                                self.selectedCategories.removeAll(where: { $0 == category })
                                            }
                                        }
                                    ))
                                }
                            }
//                            Text("Selected Categories: \(selectedCategories.map { $0.name }.joined(separator: ", ") )")
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                if formIsValid(recipe) {
                                    recipe.category = selectedCategories
                                    do {
                                        try modelContext.save()
                                        dismiss()
                                    } catch {
                                        print("An error occurred: \(error)")
                                    }
                                } else {
                                    showAlert = true
                                }
                            }) {
                                Image(systemName: "chevron.backward")
                                Text("Back")
                            }
                            .disabled(!formIsValid(recipe))
                            .alert(isPresented: $showAlert) {
                                Alert(title: Text("Error"), message: Text("All fields are required"), dismissButton: .default(Text("OK")))
                            }
                        }
                        ToolbarItem(placement: ToolbarItemPlacement.principal) {
                            Text("Edit Recipe")
                        }
                    }
                }
                else {
                    Text("No Recipe Selected")
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    let recipe = Recipe(title: "Feijoada", author: "John Doe", date: "11/29/2023", timeRequired: "3 hours", servings: "20", expertiseRequired: "Beginner", caloriesPerServing: "300", ingredients: "beans, pork, onions, etc...", instructions: "Cook for 2.5 hrs", notes: "cook on medium heat", category: [], favorite: true)
    return EditRecipeView(recipe: recipe)
}
