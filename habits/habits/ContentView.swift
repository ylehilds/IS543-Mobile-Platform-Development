//
//  ContentView.swift
//  habits
//
//  Created by Lehi Alcantara on 12/21/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\Goal.title)]) private var goals: [Goal]
    
    @Query(sort: [SortDescriptor(\Category.name)]) private var categories: [Category]
    var uniqueCategories: [Category] {
        var uniqueNames = Set<String>()
        return categories.filter { uniqueNames.insert($0.name).inserted }
    }
    
    @State private var search = ""
    @State private var showingCreateGoalSheet = false
    @State private var showingCreateCategorySheet = false
    
    @State private var isEditorPresented = false
    @State private var isNewEditorPresented = false
    
    var body: some View {
        NavigationSplitView {
            List {
                // A section of top-level abilities like browse all, search, favorites
                Section(header: Text("Goals")) {
                    NavigationLink {
                        browseAllList(goals: goals)
                    } label: {
                        Text("Browse By Goals")
                    }
                }
                
                Section(header: Text("Goals by Categories")) {
                    ForEach(uniqueCategories, id: \.self) { category in
                        let filteredGoals = goals.filter { goal in
                            goal.category?.name == category.name
                        }
                        NavigationLink(destination: browseAllList(goals: filteredGoals)) {
                            ScrollView {
                                VStack {
                                    Text(category.name)
                                }
                            }
                        }
                    }
                }
                
                Section(header: Text("Search")) {
                    NavigationLink(destination: goalSearch) {
                        Text("Goal Search")
                    }
                    
                    NavigationLink(destination: goalStatusSearch) {
                        Text("Status Search")
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
                Text("select a goal")
            }
        }
        .onAppear {
            // ran out of time on this one, but I had the beginning of it
            //            let defaults = UserDefaults.standard
            //            if !defaults.bool(forKey: "dataLoaded") {
            //                if goals.isEmpty {
            //                    initializeGoals()
            //                }
            //
            //                if categories.isEmpty {
            //                    initializeCategories()
            //                }
            //                defaults.set(true, forKey: "dataLoaded")
            //            }
            //        }
        }
    }
    
    private var goalSearch: some View {
        VStack {
            Form {
                TextField("Search", text: $search)
            }
            if search.isEmpty {
                Text("Enter a category search term")
            }
            List {
                ForEach(goals.filter { $0.category?.name.lowercased().contains(search.lowercased()) ?? false }) { goal in
                    NavigationLink(destination: GoalDetailView(goal: goal)) {
                        ScrollView {
                            VStack {
                                Text(goal.title)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private var goalStatusSearch: some View {
        VStack {
            Form {
                TextField("Search", text: $search)
            }
            if search.isEmpty {
                Text("Enter a status search term")
            }
            List {
                ForEach(goals.filter { $0.status.lowercased().contains(search.lowercased()) }) { goal in
                    NavigationLink(destination: GoalDetailView(goal: goal)) {
                        ScrollView {
                            VStack {
                                Text(goal.title)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    func browseAllList(goals: [Goal]) -> some View {
        List {
            if goals.count == 0 {
                Text("No goals yet. Tap the + button to add a goal.")
            } else {
                ForEach(goals) { goal in
                    NavigationLink(goal.title) { GoalDetailView(goal: goal) }
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
                    isNewEditorPresented.toggle()
                }) {
                    Image(systemName: "plus").imageScale(.large)
                }
                .sheet(isPresented: $isNewEditorPresented) {
                    GoalEditor(goal: nil)
                }
            }
        }
    }
    
    
     var categoriesList: some View {
        List {
            if categories.count == 0 {
                Text("No categories yet. Tap the + button to add a category.")
            } else {
                ForEach(uniqueCategories) { category in
                    NavigationLink {
                        ScrollView {
                            VStack {
                                    Text(category.name)
                                .padding()
                            }
                        }
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                NavigationLink(destination: CategoryEditor(category: category)) {
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
                    CategoryEditor(category: nil)
                }
            }
        }
    }
    
     func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(goals[index])
            }
        }
    }
    
     func deleteCategory(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(categories[index])
            }
        }
    }
    
    // ran out of time, but started it
//    private func initializeGoals() {
//        withAnimation {
//            for goal in goals {
//                modelContext.insert(goal)
//            }
//        }
//    }
//    
//    private func initializeCategories() {
//        withAnimation {
//            for category in sampleCategories {
//                modelContext.insert(category)
//            }
//        }
//    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        let sharedModelContainer: ModelContainer = {
//            let schema = Schema([
//                Goal.self,
//                Category.self
//            ])
//            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
//            
//            do {
//                return try ModelContainer(for: schema, configurations: [modelConfiguration])
//            } catch {
//                fatalError("Could not create ModelContainer: \(error)")
//            }
//        }()
//        ContentView()
//            .modelContainer(sharedModelContainer)
//    }
//}
