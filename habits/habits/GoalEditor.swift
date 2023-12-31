//
//  GoalEditor.swift
//  habits
//
//  Created by Lehi Alcantara on 12/21/23.
//

import SwiftUI
import SwiftData

struct GoalEditor: View {
    let goal: Goal?
    
    private var editorTitle: String {
        goal == nil ? "Add Goal" : "Edit Goal"
    }
    
    @State var title = ""
    @State var goalDescription = ""
    @State var selectedTimePeriod: GoalHelper.periods = .daily
    @State var selectedCategory: Category?
    @State var selectedStatus: GoalHelper.status = .notStarted
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: [SortDescriptor(\Category.name)]) private var categories: [Category]
       var uniqueCategories: [Category] {
           var uniqueNames = Set<String>()
           return categories.filter { uniqueNames.insert($0.name).inserted }
       }

    
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $title)
                
                TextField("Description", text: $goalDescription)
                
                Picker("Category", selection: $selectedCategory) {
                    Text("Select a category").tag(nil as Category?)
                    ForEach(uniqueCategories) { category in
                        Text(category.name).tag(category as Category?)
                    }
                }
                
                Picker("frequency", selection: $selectedTimePeriod) {
                    ForEach(GoalHelper.periods.allCases, id: \.self) { period in
                        Text(period.rawValue).tag(period)
                    }
                }
                
                Picker("Status", selection: $selectedStatus) {
                    ForEach(GoalHelper.status.allCases, id: \.self) { status in
                        Text(status.rawValue).tag(status)
                    }
                }
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
            if let goal {
                // Edit the incoming goal.
                title = goal.title
                goalDescription = goal.goalDescription
                selectedTimePeriod = GoalHelper.periods(rawValue: goal.timePeriod) ?? .daily
                selectedCategory = goal.category
                selectedStatus = GoalHelper.status(rawValue: goal.status) ?? .notStarted
            }
        }
    }
    
    private func save() {
        if let goal {
            // Edit the Goal.
            goal.title = title
            goal.goalDescription = goalDescription
            goal.timePeriod = selectedTimePeriod.rawValue
            goal.category = selectedCategory
            goal.status = selectedStatus.rawValue
        } else {
            // Add a Goal.
            let goal = Goal(title: title, goalDescription: goalDescription, timePeriod: selectedTimePeriod.rawValue, status: selectedStatus.rawValue, category: selectedCategory)
            goal.category = selectedCategory
            modelContext.insert(goal)
        }
    }
}

#Preview("Add Goal") {
        GoalEditor(goal: nil)
}

#Preview("Edit goal") {
    GoalEditor(goal: .init(title: "Title", goalDescription: "Description", timePeriod: "Time Period", status: "Status", category: Category(name:"Personal")))
}
