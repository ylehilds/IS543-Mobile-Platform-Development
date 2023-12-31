//
//  ContentView.swift
//  modelsRelated
//
//  Created by Lehi Alcantara on 12/17/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var recipes: [Recipe]
    @State private var showingCreateCategorySheet = false

    @Query(sort: [SortDescriptor(\Category.name)]) private var categories: [Category]
    var uniqueCategories: [Category] {
        var uniqueNames = Set<String>()
        return categories.filter { uniqueNames.insert($0.name).inserted }
    }

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(recipes) { recipe in
                    NavigationLink {
                        detailView(for: recipe)
                    } label: {
                        Text(recipe.title)
                    }
                }
                .onDelete(perform: deleteItems)
                
                // Categories
                Section(header: Text("Categories")) {
                    NavigationLink {
                        categoriesList
                    } label: {
                        Text("Categories Editor")
                    }
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }
    
    private var categoriesList: some View {
        List {
            if categories.count == 0 {
                Text("No categories yet. Tap the + button to add a category.")
            } else {
                ForEach(uniqueCategories) { category in
                    NavigationLink {
                        ScrollView {
                            VStack {
                                Text (category.name)
                                .padding()
                            }
                        }
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                NavigationLink(destination: EditCategoryView(category: category)) {
                                    Image(systemName: "pencil").imageScale(.large)
                                }
                            }
                        }
                    }
                label: {
                    Text(category.name)
                }
                }
                .onDelete(perform: deleteCategory)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItem {
                Button(action: {
                    showingCreateCategorySheet.toggle()
                }) {
                    Image(systemName: "plus").imageScale(.large)
                }
                .sheet(isPresented: $showingCreateCategorySheet) {
                    NewCategoryView()
                }
            }
        }
    }

    private func deleteCategory(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(categories[index])
            }
        }
    }
        
    private func detailView(for recipe: Recipe) -> some View {
        ScrollView {
            VStack {
                Text("title: \(recipe.title), category: \(recipe.category.map { $0.name }.joined(separator: ", "))")
            }
        }
    }
    
    private func addItem() {
        withAnimation {
            let categories = [Category(name: "Breakfast"), Category(name: "Dinner"), Category(name: "Lunch")]
            let recipe = Recipe(title: "New Recipe - " + UUID().uuidString, author: "Lehi", category: categories)
            modelContext.insert(recipe)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(recipes[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Recipe.self, inMemory: true)
}
