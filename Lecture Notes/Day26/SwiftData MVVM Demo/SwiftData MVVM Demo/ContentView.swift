//
//  ContentView.swift
//  SwiftData MVVM Demo
//
//  Created by Stephen Liddle on 12/6/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {

    // MARK: - Properties

    // We manage the ViewModel as a State property because we need to subscribe
    // to the publication of changes and trigger a re-render of this View.

    @State private var viewModel: ViewModel
    @State private var hasError = false
    @State private var errorMessage = ""

    // MARK: - Initialization

    // We need an initializer to capture the ModelContext and build the
    // ViewModel with that ModelContext.

    init(_ modelContext: ModelContext) {
        // Remember that _viewModel is the variable created by the @State
        // property wrapper.

        _viewModel = State(initialValue: ViewModel(modelContext))
    }

    // MARK: - Main body

    var body: some View {
        NavigationSplitView {
            topLevelNavigation
        } content: {
            primaryNavigationView
        } detail: {
            Text("Select an item")
        }
        .alert(isPresented: $hasError) {
            Alert(
                title: Text("Unable to Reset Database"),
                message: Text(errorMessage)
            )
        }
        .task {
            if viewModel.items.isEmpty {
                withAnimation {
                    do {
                        try viewModel.replaceAllItems(sampleItems, sampleIndependentItems, sampleAssociations)
                    } catch {
                        errorMessage = error.localizedDescription
                        hasError = true
                    }
                }
            }
        }
        .environment(viewModel)
    }

    private var primaryNavigationView: some View {
        itemsList(for: viewModel.items)
            .navigationTitle("All Items")
    }

    private var topLevelNavigation: some View {
        List {
            Section {
                NavigationLink {
                    primaryNavigationView
                } label: {
                    Text("Browse all")
                }

                NavigationLink {
                    itemsList(for: viewModel.filteredItems)
                        .navigationTitle("Filtered Items")
                } label: {
                    Text("Filtered items")
                }
            }
        }
    }

    private func addItem() {
        withAnimation {
            viewModel.addItem(
                Item(
                    title: "Chisel",
                    dependentItems: [
                        DependentItem(title: "Resin"),
                        DependentItem(title: "Metal")
                    ],
                    independentItems: []
                )
            )
        }
    }

    private func itemsList(for items: [Item]) -> some View {

        // Writing deleteItems as a nested function ensures that we have access
        // to the same array of items used to build the list (which will either
        // be the full list of items or the filtered list).

        func deleteItems(offsets: IndexSet) {
            withAnimation {
                for index in offsets {
                    viewModel.deleteItem(items[index])
                }
            }
        }

        // When we have other code above the view hierarchy, note that we need
        // to add a return statement so the compiler understands what we're doing.

        return List {
            ForEach(items) { item in
                NavigationLink {
                    List {
                        Section("Item") {
                            Text(item.title)
                        }

                        if !item.dependentItems.isEmpty {
                            Section("Dependent Items") {
                                ForEach(item.dependentItems) { dependentItem in
                                    Text(dependentItem.title)
                                }
                            }
                        }

                        if !item.independentItems.isEmpty {
                            Section("Independent Items") {
                                ForEach(item.independentItems) { independentItem in
                                    Text(independentItem.title)
                                }
                            }
                        }
                    }
                } label: {
                    Text(item.title)
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
    }
}

#Preview {
    let container = { () -> ModelContainer in
        do {
            return try ModelContainer(
                for: Item.self, IndependentItem.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: true)
            )
        } catch {
            fatalError("Failed to create ModelContainer for Items.")
        }
    }()

    return ContentView(container.mainContext)
        .modelContainer(container)
}
