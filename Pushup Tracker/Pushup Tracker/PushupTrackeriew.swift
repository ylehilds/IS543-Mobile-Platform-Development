//
//  PushupTrackerView.swift
//  Pushup Tracker
//
//  Created by Lehi Alcantara on 9/18/23.
//

import SwiftUI

struct PushupTrackerView: View {
    
    var pushupviewModel: PushupViewModel
    
    var body: some View {
        NavigationStack {
            Form {
                totalsSection
                workoutSection
            }
            .navigationTitle("Pushup Tracker")
        }
    }
    
    var totalsSection: some View {
        Section {
            HStack {
                Text("Grand Total push-ups:")
                    .bold()
                Spacer()
                Text("\(pushupviewModel.totalCount)")
            }
            HStack {
                Text("Push-ups that count for Kyle:")
                    .bold()
                Spacer()
                Text("\(pushupviewModel.pushupsThatCount)")
            }
            Button {
                // NEEDSWORK: report the total
                pushupviewModel.incrementTotal()
            } label: {
                Label("Report", systemImage: "square.and.arrow.up")
            }
        }
    }
    
    var workoutSection: some View {
        Section(header: Text("Individual Workouts")) {
            if pushupviewModel.workouts.isEmpty {
                Button {
                    // NEEDSWORK
                } label: {
                    Label("Add your first workout", systemImage: "plus.circle")
                }
            } else {
                List {
                    ForEach(pushupviewModel.workouts) { workout in
                        HStack {
                            Text(workout.dateString)
                            Spacer()
                            Text("\(workout.count)")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    PushupTrackerView(pushupviewModel: PushupViewModel())
}
