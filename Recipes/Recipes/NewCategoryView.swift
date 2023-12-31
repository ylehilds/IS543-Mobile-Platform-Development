//
//  NewCategoryView.swift
//  Recipes
//
//  Created by Lehi Alcantara on 11/30/23.
//

import SwiftUI
import SwiftData

struct NewCategoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                Spacer()
                
                Text("New Category").font(.headline)
                Spacer()
                
                Button("Save") {
                    if name.isEmpty {
                        showAlert = true
                    } else {
                        addCategory()
                        dismiss()
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text("Category name is required"), dismissButton: .default(Text("OK")))
                }
            }
            .padding()
            Form {
                TextField("Name", text: $name, axis: .vertical)
            }
        }
    }
    
    private func addCategory() {
        withAnimation {
            let category = Category(name: name)
            modelContext.insert(category)
        }
    }
}

struct NewCategoryView_Previews: PreviewProvider {
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
        NewCategoryView()
            .modelContainer(sharedModelContainer)
    }
}
