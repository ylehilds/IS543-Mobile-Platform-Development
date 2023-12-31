//
//  ContentView.swift
//  myNotification
//
//  Created by Lehi Alcantara on 12/16/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        secondLayerView(item: item)
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteItems)
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
        } content: {
            Text("select a menu item")
        } detail: {
            NavigationStack {
                Text("Select an item")
            }
        }
    }
    
    private func secondLayerView(item: Item) -> some View {
        NavigationLink {
            Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
        } label: {
            Text("second layer item navigation link")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
