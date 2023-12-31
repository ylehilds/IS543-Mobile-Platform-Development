//
//  MediumDateFormatter.swift
//  Pushup Tracker
//
//  Created by Lehi Alcantara on 9/24/23.
//

import Foundation

class MediumDateFormatter {
    static let shared = MediumDateFormatter()
    
    let dateFormatter: DateFormatter
    
    private init() {
        dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
    }
    
    func string(from date: Date) -> String {
        dateFormatter.string(from: date)
    }
}

// NOTE: Here is an alternative way to privade similar functionality
// to the code above without using the singleton pattern. Instead
// of calculating MediumDateFormatter.shared.string(from: date) you
// would call mediumString(from: date).

private let dateFormatter = {
    let formatter = DateFormatter()
    
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    
    return formatter
}()

func mediumString(from date: Date) -> String {
    dateFormatter.string(from: date)
}
