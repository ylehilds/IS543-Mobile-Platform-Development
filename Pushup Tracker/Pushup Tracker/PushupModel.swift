//
//  PushupModel.swift
//  Pushup Tracker
//
//  Created by Lehi Alcantara on 9/18/23.
//

import Foundation

struct PushupModel {
    
    // MARK: - Properties
    
    var workouts: Array<WorkoutReport>
    
    // MARK: - Initialization
    
    init() {
        // NEEDSWORK: read the workouts from storage
        
        workouts = []
        
        addWorkout(count: 51, day: 3, month: 8, year: 2023)
        addWorkout(count: 50, day: 4, month: 8, year: 2023)
        addWorkout(count: 51, day: 7, month: 8, year: 2023)
        addWorkout(count: 58, day: 9, month: 8, year: 2023)
        addWorkout(count: 64, day: 14, month: 8, year: 2023)
        addWorkout(count: 73, day: 16, month: 8, year: 2023)
        addWorkout(count: 80, day: 19, month: 8, year: 2023)
        addWorkout(count: 90, day: 21, month: 8, year: 2023)
        addWorkout(count: 105, day: 23, month: 8, year: 2023)
        addWorkout(count: 50, day: 24, month: 8, year: 2023)
        addWorkout(count: 50, day: 25, month: 8, year: 2023)
        addWorkout(count: 50, day: 26, month: 8, year: 2023)
        addWorkout(count: 122, day: 28, month: 8, year: 2023)
        addWorkout(count: 123, day: 30, month: 8, year: 2023)
        addWorkout(count: 50, day: 1, month: 9, year: 2023)
        addWorkout(count: 50, day: 4, month: 9, year: 2023)
        addWorkout(count: 50, day: 5, month: 9, year: 2023)
        addWorkout(count: 50, day: 6, month: 9, year: 2023)
        addWorkout(count: 50, day: 7, month: 9, year: 2023)
        addWorkout(count: 50, day: 8, month: 9, year: 2023)
        addWorkout(count: 50, day: 9, month: 9, year: 2023)
        addWorkout(count: 144, day: 11, month: 9, year: 2023)
        addWorkout(count: 170, day: 13, month: 9, year: 2023)
        addWorkout(count: 180, day: 15, month: 9, year: 2023)
        addWorkout(count: 190, day: 18, month: 9, year: 2023)
        addWorkout(count: 205, day: 20, month: 9, year: 2023)
        addWorkout(count: 50, day: 22, month: 9, year: 2023)
        addWorkout(count: 225, day: 25, month: 9, year: 2023)
        addWorkout(count: 253, day: 27, month: 9, year: 2023)
        addWorkout(count: 52, day: 29, month: 9, year: 2023)
        addWorkout(count: 100, day: 30, month: 9, year: 2023)
        addWorkout(count: 280, day: 2, month: 10, year: 2023)
    }
    
    // MARK: - Helpers
    
    mutating func addWorkout(count: Int, day: Int, month: Int, year: Int) {
        var dateComponents = DateComponents()
        
        dateComponents.day = day
        dateComponents.month = month
        dateComponents.year = year
        
        if count > 0 {
            if let date = Calendar.current.date(from: dateComponents) {
                print("Date in medium style: \(MediumDateFormatter.shared.string(from: date))")
                let workout = WorkoutReport(count: count, date: date)
                
                if workouts.isDateUnique(withRespectTo: workout) {
                    workouts.append(workout)
                }
            }
        }
    }
    
    // MARK: - Nested types

    struct WorkoutReport: Identifiable, Dated {
        var id = UUID()
        var count = 0
        var date = Date()
    }
}
