//
//  Dated.swift
//  Pushup Tracker
//
//  Created by Lehi Alcantara on 9/20/23.
//

import Foundation

protocol Dated {
    var date: Date { get }
}

extension Dated {
    func yearMonthDate() -> (year: Int, month: Int, day: Int) {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        
        guard let year = components.year, let month = components.month, let day = components.day else {
            return (0, 0, 0)
        }
        
        return (year, month, day)
    }
    
    func hasSameDateAs (as other: Self) -> Bool {
        let components1 = yearMonthDate()
        let components2 = other.yearMonthDate()
        
        return components1.year == components2.year && components1.month == components2.month && components1.day == components2.day
    }
}
