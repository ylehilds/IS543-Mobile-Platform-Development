//
//  ContentView.swift
//  Recipes
//
//  Created by Lehi Alcantara on 11/21/23.
//

import SwiftUI
import SwiftData
import MarkdownUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\Recipe.title)]) private var recipes: [Recipe]
    
    @Query(sort: [SortDescriptor(\Category.name)]) private var categories: [Category]
    var uniqueCategories: [Category] {
        var uniqueNames = Set<String>()
        return categories.filter { uniqueNames.insert($0.name).inserted }
    }
    
    @State private var search = ""
    @State private var showingCreateRecipeSheet = false
    @State private var showingCreateCategorySheet = false
    
    var body: some View {
        NavigationSplitView {
            List {
                // A section of top-level abilities like browse all, search, favorites
                Section(header: Text("Recipes")) {
                    NavigationLink {
                        browseAllList(recipes: recipes)
                    } label: {
                        Text("Browse By Title")
                    }
                    NavigationLink {
                        browseFavoritesList(recipes: recipes.filter { $0.favorite })
                    } label: {
                        Text("Browse By Favorites")
                    }
                    
                    NavigationLink(destination: recipeSearch) {
                        Text("Recipe Search")
                    }
                }
                
                Section(header: Text("Recipes by Categories")) {
                    ForEach(uniqueCategories, id: \.self) { category in
                        NavigationLink(destination: browseAllList(recipes: recipes.filter { recipe in
                            recipe.category.contains(where: { $0.name == category.name })
                        })) {
                            ScrollView {
                                VStack {
                                    Markdown {
                                        category.name
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Categories
                Section(header: Text("Categories")) {
                    NavigationLink {
                        categoriesList
                    } label: {
                        Text("Categories Editor")
                    }
                }
            }
        } content: {
            Text("select a menu item")
        } detail: {
            NavigationStack {
                Text("select a recipe")
            }
        }
        .onAppear {
            let defaults = UserDefaults.standard
            if !defaults.bool(forKey: "dataLoaded") {
                if recipes.isEmpty {
                    initializeRecipes()
                }
                
                if categories.isEmpty {
                    initializeCategories()
                }
                defaults.set(true, forKey: "dataLoaded")
            }
        }
    }
    
    private func browseAllList(recipes: [Recipe]) -> some View {
        List {
            if recipes.count == 0 {
                Text("No recipes yet. Tap the + button to add a recipe.")
            } else {
                ForEach(recipes) { recipe in
                    NavigationLink(recipe.title) { RecipeDetailView(recipe: recipe) }
                }
                .onDelete(perform: deleteItems)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItem {
                Button(action: {
                    showingCreateRecipeSheet.toggle()
                }) {
                    Image(systemName: "plus").imageScale(.large)
                }
                .sheet(isPresented: $showingCreateRecipeSheet) {
                    NewRecipeView()
                }
            }
        }
    }
    
    private func browseFavoritesList(recipes: [Recipe]) -> some View {
        List {
            if recipes.count == 0 {
                Text("No favorites recipes yet. Favorite a recipe before choosing this menu.")
            } else {
                ForEach(recipes) { recipe in
                    NavigationLink {
                        RecipeDetailView(recipe: recipe)
                    } label: {
                        Text(recipe.title)
                    }
                }
                .onDelete(perform: deleteItems)
            }
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
                                Markdown {
                                    category.name
                                }
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
    
    private var recipeSearch: some View {
        VStack {
            Form {
                TextField("Search", text: $search)
            }
            if search.isEmpty {
                Text("Enter a search term (title, ingredients, or notes)")
            }
            List {
                ForEach(recipes.filter { $0.title.lowercased().contains(search.lowercased()) || $0.ingredients.lowercased().contains(search.lowercased()) || $0.notes.lowercased().contains(search.lowercased()) }) { recipe in
                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                        ScrollView {
                            VStack {
                                Markdown {
                                    recipe.title
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(recipes[index])
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
    
    private func initializeRecipes() {
        withAnimation {
            for recipe in sampleRecipes {
                modelContext.insert(recipe)
            }
        }
    }
    
    private func initializeCategories() {
        withAnimation {
            for category in sampleCategories {
                modelContext.insert(category)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let sharedModelContainer: ModelContainer = {
            let schema = Schema([
                Recipe.self,
                Category.self
            ])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
            
            do {
                return try ModelContainer(for: schema, configurations: [modelConfiguration])
            } catch {
                fatalError("Could not create ModelContainer: \(error)")
            }
        }()
        ContentView()
            .modelContainer(sharedModelContainer)
    }
}
