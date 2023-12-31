//
//  EditCategoryView.swift
//  Recipes
//
//  Created by Lehi Alcantara on 11/30/23.
//

import SwiftUI
import SwiftData

struct EditCategoryView: View {
    var category: Category?
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showAlert = false
    
    func formIsValid(_ category: Category) -> Bool {
        !category.name.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if let category {
                    Form {
                        Section(header: Text("Category")) {
                            TextField("Category", text: Binding(get: { category.name }, set: { newValue in
                                category.name = newValue
                                if category.name.isEmpty {
                                    showAlert = true
                                }
                            }), axis: .vertical)
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                if formIsValid(category) {
                                    dismiss()
                                } else {
                                    showAlert = true
                                }
                            }) {
                                Image(systemName: "chevron.backward")
                                Text("Back")
                            }
                            .disabled(!formIsValid(category))
                            .alert(isPresented: $showAlert) {
                                Alert(title: Text("Error"), message: Text("Category name is required"), dismissButton: .default(Text("OK")))
                            }
                        }
                        ToolbarItem(placement: ToolbarItemPlacement.principal) {
                            Text("Edit Category")
                        }
                    }
                }
                else {
                    Text("No Category Selected")
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    let category = Category(name: "Desserts")
    return EditCategoryView(category: category)
}
