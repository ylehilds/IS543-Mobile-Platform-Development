//
//  PushupViewModel.swift
//  Pushup Tracker
//
//  Created by Lehi Alcantara on 9/18/23.
//

import Foundation

@Observable class PushupViewModel {
    
    // MARK - Contants
    
    private struct Constants {
        static let maxDaysPerMonth = 31
        
        static let maxDailyPushupsForKyle = 50
        static let maxDateValueForKyle =  11 * maxDaysPerMonth + 10
        static let minDateValueForKyle =  8 * maxDaysPerMonth + 3
        static let secondsPerDay:TimeInterval =  60 * 60 * 24
    }
    
    // MARK: - Properties
    
    private var pushupData = PushupModel()
    
    // MARK: - Model access
    
    var pushupsThatCount: Int {
        var counts = [String: (count: Int, excess: Int, date: Date)]()
        
        pushupData.workouts
            .filter { dateCountsForKyle($0.date) }
            .forEach { workoutReport in
                let key = dateKey(for: workoutReport.date)
                
                counts[key] = (max(workoutReport.count, Constants.maxDailyPushupsForKyle),
                               max(workoutReport.count - Constants.maxDailyPushupsForKyle, 0),
                               workoutReport.date)
            }
        counts.keys.sorted().forEach{ key in
            guard let value = counts[key] else {
                return
            }
            
            let excess = value.excess
            let date = value.date
            
            if excess > 0 {
                let subsequentDay = date.addingTimeInterval(Constants.secondsPerDay)
                let previousDay = date.addingTimeInterval(-Constants.secondsPerDay)
                let subsequentKey = dateKey(for: subsequentDay)
                let previousKey = dateKey(for: previousDay)
                
                if dateCountsForKyle(subsequentDay) && counts[subsequentKey] == nil {
                    counts[subsequentKey] = (min(excess, Constants.maxDailyPushupsForKyle), 0, subsequentDay)
                } else if dateCountsForKyle(previousDay) && counts[previousKey] == nil {
                    counts[previousKey] = (min(excess, Constants.maxDailyPushupsForKyle), 0, previousDay)
                } else if let subsequentValue = counts[subsequentKey],
                          dateCountsForKyle(subsequentDay),
                          subsequentValue.count < Constants.maxDailyPushupsForKyle {
                    counts[subsequentKey] = (min(subsequentValue.count + excess, Constants.maxDailyPushupsForKyle), 0, subsequentDay)
                } else if let previousValue = counts[previousKey],
                          dateCountsForKyle(previousDay),
                          previousValue.count < Constants.maxDailyPushupsForKyle {
                    counts[previousKey] = (min(previousValue.count + excess, Constants.maxDailyPushupsForKyle), 0, previousDay)
                }
            }
        }
        return counts.reduce(0) { $0 + min($1.value.count, Constants.maxDailyPushupsForKyle)}
    }
    
    var totalCount: Int {
        pushupData.workouts.reduce(0) { $0 + $1.count}
    }
    
    var workouts: [PushupModel.WorkoutReport] {
        pushupData.workouts
            .sorted { $0.date > $1.date
                
            }
    }
    
    // MARK: - User Intents

    func addWorkout(date: Date, count: Int) {
        //NEEDSWORK
    }
    
    func deleteWorkout(id: UUID) {
        //NEEDSWORK
    }
    
    func updateWorkout(id: UUID, date: Date, count: Int) {
        //NEEDSWORK
    }
    
    func incrementTotal() {
//        pushupData.grandTotal = pushupData.grandTotal + 1
    }
    
    // MARK: - Helpers
    
    func dateCountsForKyle(_ date: Date) -> Bool {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let currentYearComponents = Calendar.current.dateComponents([.year], from: Date())
        
        guard let year = components.year, let month = components.month, let day = components.day, let currentYear = currentYearComponents.year else {
            return false
        }
        
        let dateValue = month * Constants.maxDaysPerMonth + day
        
        return dateValue >= Constants.minDateValueForKyle
            && dateValue <= Constants.maxDateValueForKyle
            && year == currentYear
    }
    
    func dateKey(for date: Date) -> String {
        let components = Calendar.current.dateComponents([.month, .day], from: date)
        guard let month = components.month, let day = components.day else {
            return ""
        }
        return "\(month)-\(day)"
    }
}
