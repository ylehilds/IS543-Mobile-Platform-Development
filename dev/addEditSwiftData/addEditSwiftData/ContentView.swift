//
//  ContentView.swift
//  addEditSwiftData
//
//  Created by Lehi Alcantara on 12/19/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Animal.name) private var animals: [Animal]
    @State private var isEditorPresented = false
    @State private var isNewEditorPresented = false


    var body: some View {
        NavigationSplitView {
            List {
                ForEach(animals) { animal in
                    NavigationLink {
                        detailView(animal: animal)
                    } label: {
                        Text("\(animal.name) - \(animal.diet.rawValue)")
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
                ToolbarItem {
                    Button(action: {
                        isNewEditorPresented.toggle()
                    }) {
                        Image(systemName: "plus").imageScale(.large)
                    }
                    .sheet(isPresented: $isNewEditorPresented) {
                        AnimalEditor(animal: nil)
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
        .onAppear {
            AnimalCategory.reloadSampleData(modelContext: modelContext)
        }
    }
    
    private func detailView(animal: Animal) -> some View {
        Text("\(animal.name)")
            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    NavigationStack {
//                        ZStack {
//                            NavigationLink(destination: AnimalEditor(animal: item)) {
//                                Image(systemName: "pencil").imageScale(.large)
//                            }
//                        }
//                    }
//                }
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    NavigationStack {
//                        ZStack {
//                            NavigationLink(destination: AnimalEditor(animal: nil)) {
//                                Image(systemName: "plus").imageScale(.large)
//                            }
//                        }
//                    }
//                }
                ToolbarItem {
                    Button(action: {
                        isEditorPresented.toggle()
                    }) {
                        Image(systemName: "pencil").imageScale(.large)
                    }
                    .sheet(isPresented: $isEditorPresented) {
                        AnimalEditor(animal: animal)
                    }
                }
            }
    }

    private func addItem() {
        withAnimation {
            let newItem = Animal(name: "Lehi", diet: .carnivorous)
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(animals[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Animal.self, inMemory: true)
}
