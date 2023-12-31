//
//  CategoryEditor.swift
//  habits
//
//  Created by Lehi Alcantara on 12/21/23.
//

import SwiftUI
import SwiftData


//struct CategoryEditor: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//#Preview {
//    CategoryEditor()
//}


struct CategoryEditor: View {
    let category: Category?
    
    private var editorTitle: String {
        category == nil ? "Add Category" : "Edit Category"
    }
    
    @State var name = ""
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Category.name) private var categories: [Category]
    

    
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
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
            if let category {
                // Edit the incoming category.
                name = category.name
            }
        }
    }
    
    private func save() {
        if let category {
            // Edit the Category.
            category.name = name
        } else {
            // Add a Category.
            let category = Category(name: name)
            modelContext.insert(category)
        }
    }
}

#Preview("Add Category") {
        CategoryEditor(category: nil)
}

#Preview("Edit goal") {
    CategoryEditor(category: .init(name: "Title"))
}
