//
//  GoalDetailView.swift
//  habits
//
//  Created by Lehi Alcantara on 12/21/23.
//

import SwiftUI
import SwiftData

struct GoalDetailView: View {
    let goal: Goal?
    
    @State private var isEditorPresented = false
    
    var body: some View {
        if let goal = goal {
            ScrollView {
                VStack {
                    Text(goal.title)
                        .padding()
                    Text("description: \(goal.goalDescription)")
                        .padding()
                    Text("frequency: \(goal.timePeriod)")
                        .padding()
                    Text("status: \(goal.status)")
                        .padding()
                    Text("category: \(goal.category?.name ?? "")")
                        .padding()
                }
            }
            .toolbar {
              
                
                ToolbarItem {
                    Button(action: {
                        isEditorPresented.toggle()
                    }) {
                        Image(systemName: "pencil").imageScale(.large)
                    }
                    .sheet(isPresented: $isEditorPresented) {
                        GoalEditor(goal: goal)
                    }
                }
            }
        }
        else {
            Text("Select a Goal!")
        }
    }
}

#Preview {
    let goal = Goal(title: "Title", goalDescription: "Description", timePeriod: "Time Period", status: "Status", category: Category(name:"Personal"))
    return GoalDetailView(goal: goal)
}
